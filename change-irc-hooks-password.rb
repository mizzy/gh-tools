#!/usr/bin/env ruby

require 'pit'
require 'octokit'

password = ARGV[0]

if ! password
  puts "Usage #{$0} password"
  exit
end

config = Pit.get('github', :require => {
                   'username' => 'Your user name of GitHub Enterprise',
                   'password' => 'Your password of GitHub Enterprise',
                 })
octokit = Octokit::Client.new(:login => config['username'], :password => config['password'])

octokit.orgs.each do |org|
  org = org.login
  next unless org.match(/^paperboy-.*/)
  octokit.org_repos(org).each do |repo|
    repo = repo.full_name
    octokit.hooks(repo).each do |hook|
      if hook.name == 'irc' and hook.config.server == 'irc.paperboy.co.jp'
        puts "Changing IRC hook password of #{repo} ..."
        hook.config.password = password
        octokit.edit_hook(repo, hook.id, hook.name, hook.config)
      end
    end
  end
end
