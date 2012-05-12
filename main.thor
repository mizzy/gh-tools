# -*- coding: utf-8 -*-

require 'bundler/setup'
require 'pit'
require 'octokit'

class GhTools < Thor
  private
  def octokit
    config = Pit.get('github', :require => {
                       'username' => 'Your user name of GitHub',
                       'password' => 'Your password of GitHub',
                     })
    Octokit::Client.new(:login => config['username'], :password => config['password'])
  end

  def find_team(organization, team)
    teams = octokit.organization_teams(organization)
    found = nil
    teams.each do |t|
      found = t if t.name == team
    end
    return found
  end

  def add_team_member(team, user)
    octokit.add_team_member(team.id, user)
  end
  
  def remove_team_member(team, user)
    octokit.remove_team_member(team.id, user)
  end

  def publicize_member(organization, user)
    octokit.publicize_member(organization, user)
  end

end

::Octokit::Client.send(:define_method, 'publicize_member') do |organization, user|
  begin
    put("orgs/#{organization}/public_members/#{user}")
  rescue
  end
end
