# -*- coding: utf-8 -*-

require 'bundler/setup'
require 'pit'
require 'octokit'
require 'net/https'
require 'uri'

class GhTools < Thor
  private
  def octokit
    if options.ghe
      config = Pit.get('ghe', :require => {
                         'access_token' => 'Your access token of GitHub Enterprise',
                       })
      Octokit.configure do |c|
        c.api_endpoint = 'http://ghe.tokyo.pb/api/v3'
        c.web_endpoint = 'http://ghe.tokyo.pb/'
      end
    else
      config = Pit.get('github', :require => {
                         'access_token' => 'Your access token of GitHub',
                       })
    end

    Octokit::Client.new(:access_token => config['access_token'])
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
    octokit.publicize_membership(organization, user)
  end

  def unpublicize_member(organization, user)
    octokit.unpublicize_membership(organization, user)
  end

  def find_team_members(team)
    members = []
    octokit.team_members(team.id).each do |member|
      members << member.login
    end
    members.sort
  end

  def find_organization_members(organization)
    octokit.organization_members(organization)
  end

  def have_avatar?(url)
    url = URI.parse(url)
    https = Net::HTTP.new(url.host)
    res = https.head(url.path + '?' + url.query)
    if res.code == "200"
      return true
    else
      return false
    end
  end

end
