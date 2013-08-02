#!/usr/bin/env ruby

require 'pit'
require 'octokit'

exclude_users = %w(ghost myokoo harasou)
exclude_orgs  = %w(kiban)
owners        = %w(mizzy antipop hsbt hiroya)


Octokit.configure do |c|
  c.api_endpoint = 'http://ghe.tokyo.pb/api/v3'
  c.web_endpoint = 'http://ghe.tokyo.pb/'
end

config = Pit.get('ghe', :require => {
                   'username' => 'Your user name of GitHub Enterprise',
                   'password' => 'Your password of GitHub Enterprise',
                 })
octokit = Octokit::Client.new(:login => config['username'], :password => config['password'])

users   = []
last_id = 0
loop do
  octokit.all_users(:since => last_id).each do |user|
    next unless user.type == 'User'
    next if exclude_users.include?(user.login)
    users << { :id => user.id, :login => user.login }
  end
  break if last_id == users[-1][:id]
  last_id = users[-1][:id]
end

orgs = []
octokit.orgs.each do |org|
  next if exclude_orgs.include?(org.login)
  orgs << org.login
end

users.each do |user|
  user = user[:login]
  puts "Adding user #{user} to all/paperboy ..."
  `thor member:add --user=#{user} --organization=all --team=paperboy --ghe`
end

puts `thor member:sync --srcorg=all --srcteam=paperboy --destorg=all --destteam=paperboy-rw --ghe`

orgs.each do |org|
  paperboy_team = nil

  owners.each do |owner|
    puts `thor member:add --user=#{owner} --organization=#{org} --team=Owners --ghe`
  end
  
  octokit.org_teams(org).each do |team|
    if team.name.match(/^paperboy$/)
      paperboy_team = team
    end
  end

  unless paperboy_team
    puts "Creating team paperboy ..."
    octokit.create_team(org, { name: 'paperboy', permission: 'pull' })
  end

  octokit.org_repos(org).each do |repo|
    next if repo.full_name.match(/\-secret$/)
    puts "Adding #{repo.full_name} to paperboy ..."
    octokit.add_team_repo(paperboy_team.id, repo.full_name)
  end

  if org != 'all'
    puts `thor member:sync --srcorg=all --srcteam=paperboy --destorg=#{org} --destteam=paperboy --ghe`
  end

end
