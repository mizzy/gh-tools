#!/usr/bin/env ruby

require 'pit'
require 'octokit'

def octokit
  config = Pit.get('github', :require => {
                     'username' => 'Your user name of GitHub',
                     'password' => 'Your password of GitHub',
                   })
  Octokit::Client.new(:login => config['username'], :password => config['password'])
end

octokit.repos.each do |repo|
  next if repo.owner.login != 'mizzy'
  octokit.update_subscription("mizzy/#{repo.name}", {subscribed: true})
end
