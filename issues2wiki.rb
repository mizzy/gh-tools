#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'octokit'
require 'pit'

conf = Pit.get('github', :require => {
                 'username' => 'Your user name of GitHub',
                 'password' => 'Your password of GitHub',
               })


client = Octokit::Client.new(:login => conf['username'],
                             :password => conf['password'])

milestones = {}

issues = client.list_issues('paperboy-sqale/sqale-app', { per_page: 1000 })
issues.each do |issue|
  milestone = issue.milestone
  milestone = milestone ? milestone.title : "マイルストーンなし"
  milestones[milestone] = [] unless milestones[milestone]
  milestones[milestone] << issue
end

milestones.each_key do |milestone|
  puts "## #{milestone}\n"
  puts "Title|Assignee"
  puts "------------- | -------------"
  milestones[milestone].each do |issue|
    assignee = issue.assignee
    assignee = assignee ? assignee.login : "アサインなし"
    puts "#{issue.title} | #{assignee}"
  end
  puts "\n\n----\n\n"
end
