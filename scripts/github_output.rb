#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'json'
require 'open3'

def fetch_json(cmd)
  stdout, stderr, status = Open3.capture3 cmd
  abort "Error running command: #{cmd}\n#{stderr}" unless status.success?
  JSON.parse stdout
end

def current_branch
  `git rev-parse --abbrev-ref HEAD`.strip.tap do
    abort 'Could not detect branch name. Are you in a git repository?' unless $CHILD_STATUS.success?
  end
end

branch = current_branch
abort 'Could not detect branch name. Are you in a git repository?' if branch.empty?

runs = fetch_json "gh run list --branch '#{branch}' --status failure --limit 1 --json databaseId"
abort "No failed runs found for branch '#{branch}'." if runs.empty?

run_id = runs.first['databaseId']
run_data = fetch_json "gh run view #{run_id} --json jobs"
failed_jobs = run_data['jobs']&.select { |j| j['conclusion'] == 'failure' } || []

abort 'No specific failing jobs were found.' if failed_jobs.empty?

failed_jobs.each do |job|
  system "gh run view --job #{job['databaseId']} --log"
end
