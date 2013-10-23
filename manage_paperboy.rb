#!/usr/bin/env ruby

require 'pit'
require 'octokit'

file = ARGV[0]

if ! file
  puts "Usage #{$0} file"
  exit
end

config = Pit.get('github', :require => {
                   'username' => 'Your user name of GitHub',
                   'password' => 'Your password of GitHub',
                 })
octokit = Octokit::Client.new(:login => config['username'], :password => config['password'])

puts `thor member:bulk_add --file=#{file} --organization=paperboy-all --team=paperboy`

puts `thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-all --destteam=paperboy-rw`

owners = %w(mizzy kentaro hsbt kuboq lamanotrama udzura)

octokit.orgs.each do |org|
  org = org.login
  next unless org.match(/^paperboy-.*/)
  puts "Processing #{org} ..."

  owners.each do |owner|
    puts `thor member:add --user=#{owner} --organization=#{org} --team=Owners`
  end

  paperboy_team = nil
  deployer_team = nil
  octokit.org_teams(org).each do |team|
    if team.name.match(/^paperboy$/)
      paperboy_team = team
    elsif team.name == 'Deployers'
      deployer_team = team
    end

  end

  unless paperboy_team
    puts "Creating team paperboy ..."
    octokit.create_team(org, { name: 'paperboy', permission: 'pull' })
  end

  octokit.org_repos(org, { type: 'private' }).each do |repo|
    puts "Adding #{repo.full_name} to paperboy ..."
    octokit.add_team_repo(paperboy_team.id, repo.full_name)
    if org == 'paperboy-all'
      puts "Adding #{repo.full_name} to Deployers ..."
      octokit.add_team_repo(deployer_team.id, repo.full_name)
    end
  end

  if org != 'paperboy-all'
    puts `thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=#{org} --destteam=paperboy`
  end

end
