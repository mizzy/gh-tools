class Member < GhTools

  desc 'add', 'Add a member to a organization'
  method_options organization: :string,
                 team:         :string,
                 user:         :string,
                 public:       :boolean
  def add
    organization = options.organization
    team         = options.team
    user         = options.user

    team    = find_team(organization, team)
    members = find_team_members(team)

    unless members.include?(user)
      puts "Adding #{user} to #{team} of #{organization} ..."
      add_team_member(team, user)
      publicize_member(organization, user) if options.public
    end
  end

  desc 'bulk_add', 'Add members to a origanization'
  method_options organization: :string,
                 team:         :string,
                 file:         :string,
                 public:       :boolean
  def bulk_add
    organization = options.organization
    team         = options.team

    team    = find_team(organization, team)
    members = find_team_members(team)

    File.open(options.file) do |f|
      while line = f.gets
        user = line.split(/\s+/)[0]
        unless members.include?(user)
          puts "Adding #{user} to #{organization}/#{team.name} ..."
          add_team_member(team, user)
          publicize_member(organization, user) if options.public
        end
      end
    end
  end

  desc 'remove', 'Remove a member from a organization'
  method_options organization: :string,
                 team:         :string,
                 user:         :string
  def remove
    organization = options.organization
    team         = options.team
    user         = options.user

    team = find_team(organization, team)
    puts "Removing #{user} #{organization}/#{team.name} ..."
    remove_team_member(team, user)
  end

  desc 'unpublicize', "Unpublicize a users's membership"
  method_options organization: :string,
                 user:         :string
  def unpublicize
    unpublicize_member(options.organization, options.user)
  end

  desc 'publicize', "Publicize a users's membership"
  method_options organization: :string,
                 user:         :string
  def publicize
    publicize_member(options.organization, options.user)
  end
  
  desc 'unpublicize_if_no_icons', 'Unpublicize users who do not have icon settings.'
  method_options organization: :string
  def unpublicize_if_no_icons
    find_organization_members(options.organization).each do |member|
      unless have_avatar?(member.avatar_url)
        begin
          puts member.login
          unpublicize_member(options.organization, member.login)
        rescue
        end
      end
    end
  end


  desc 'sync', 'sync members from one team to another'
  method_options srcorg:   :string,
                 srcteam:  :string,
                 destorg:  :string,
                 destteam: :string
  def sync
    src_org   = options.srcorg
    src_team  = options.srcteam
    dest_org  = options.destorg
    dest_team = options.destteam

    src_team    = find_team(src_org, src_team)
    src_members = find_team_members(src_team)

    dest_team    = find_team(dest_org, dest_team)
    dest_members = find_team_members(dest_team)

    members_to_add = src_members - dest_members
    members_to_add.each do |member|
      puts "Adding #{member} of #{src_org}/#{src_team.name} to #{dest_org}/#{dest_team.name} ..."
      `thor member:add --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}`
    end

    members_to_remove = dest_members - src_members
    members_to_remove.each do |member|
      puts "Rmoving #{member} of #{src_org}/#{src_team.name} to #{dest_org}/#{dest_team.name} ..."
      `thor member:remove --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}`
    end

  end

end
