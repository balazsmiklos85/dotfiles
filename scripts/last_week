#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

author = `git config user.name`.strip
monday = Date.today.prev_day (Date.today.cwday - 1) % 7
commits = `git log main --author='#{author}' --since='#{monday} 00:00:00' --pretty=format:%s`

puts commits.empty? ? 'No commits found since Monday.' : commits
