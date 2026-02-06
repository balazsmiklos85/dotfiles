#!/usr/bin/env ruby

require 'date'

author = `git config user.name`.strip
monday_date = Date.today - (Date.today.wday - 1) % 7
command = "git log main --author='#{author}' --since='#{monday_date} 00:00:00' --pretty=format:%s"
commits = `#{command}`
if commits.empty?
  puts "No commits found since Monday."
else
  puts commits
end
