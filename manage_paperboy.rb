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

puts `thor member:bulk_add --file=paperboy.txt --organization=paperboy-all --team=paperboy --public`

puts `thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-all --destteam=paperboy-rw`

owners = %w(mizzy kentaro hsbt)

octokit.orgs.each do |org|
  org = org.login
  next unless org.match(/^paperboy-.*/)
  puts "Processing #{org} ..."

  owners.each do |owner|
    puts `thor member:add --user=#{owner} --organization=#{org} --team=Owners`
  end

  paperboy_team = nil
  octokit.org_teams(org).each do |team|
    if team.name.match(/^paperboy$/)
      paperboy_team = team
    end
  end

  unless paperboy_team
    puts "Creating team paperboy ..."
    octokit.create_team(org, { name: 'paperboy', permission: 'pull' })
  end

  octokit.org_repos(org, { type: 'private' }).each do |repo|
    puts "Adding #{repo.full_name} to paperboy ..."
    octokit.add_team_repo(paperboy_team.id, repo.full_name)
  end

  if org != 'paperboy-all'
    puts `thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=#{org} --destteam=paperboy`
  end

end
