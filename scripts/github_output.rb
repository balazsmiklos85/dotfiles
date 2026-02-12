#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'json'

def fetch_json(cmd)
  output = `#{cmd}`
  unless $CHILD_STATUS.success?
    abort "Error running command: #{cmd}\nEnsure you are in a git repository with an active PR."
  end

  JSON.parse(output)
end

branch_name = `git rev-parse --abbrev-ref HEAD`.strip
abort 'Could not detect branch name. Are you in a git repository?' if branch_name.empty?

runs = fetch_json "gh run list --branch '#{branch_name}' --status failure --limit 1 --json databaseId"
abort "No failed runs found for branch '#{branch_name}'." if runs.empty?

run_id = runs[0]['databaseId']
run_data = fetch_json "gh run view #{run_id} --json jobs"
failed_jobs = run_data['jobs'].select { |j| j['conclusion'] == 'failure' }
abort 'No specific failing jobs were found.' if failed_jobs.empty?

failed_jobs.each do |job|
  IO.popen("gh run view --job #{job['databaseId']} --log", 'r') do |io|
    io.each_line do |line|
      print line
    end
  end
end
