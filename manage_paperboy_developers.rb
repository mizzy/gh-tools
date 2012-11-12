#!/usr/bin/env ruby

require 'pit'
require 'octokit'

file = ARGV[0]

if ! file
  puts "Usage #{$0} file"
  exit
end

def octokit
  config = Pit.get('github', :require => {
                     'username' => 'Your user name of GitHub',
                     'password' => 'Your password of GitHub',
                   })
  Octokit::Client.new(:login => config['username'], :password => config['password'])
end

puts `thor member:bulk_add --file=#{file} --organization=paperboy-all --team=Developers`

teams = octokit.org_teams('paperboy-all')

team_id = nil
teams.each do |team|
  if team.name == 'Developers'
    team_id = team.id
  end
end

octokit.org_repos('paperboy-all', { type: 'private' }).each do |repo|
  puts "Adding #{repo.full_name} to paperboy ..."
  octokit.add_team_repo(team_id, repo.full_name)
end

