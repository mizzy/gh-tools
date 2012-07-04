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

octokit.orgs.each do |org|
  org = org.login
  next unless org.match(/^paperboy-.*/)

  paperboy_team = nil
  octokit.org_teams(org).each do |team|
    if team.name.match(/^paperboy$/)
      paperboy_team = team
    end
  end

  unless paperboy_team
    # create team paperboy unless it exists
  end

  octokit.org_repos(org, { type: 'private' }).each do |repo|
    octokit.add_team_repo(paperboy_team.id, repo.full_name)
  end

end
