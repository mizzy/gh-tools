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

    team = find_team(organization, team)
    add_team_member(team, user)
    publicize_member(organization, user) if options.public
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
      while user = f.gets
        user.strip!
        unless members.include?(user)
          puts "Adding #{user} ..."
          add_team_member(team, user)
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
    remove_team_member(team, user)
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
      puts "thor member:add --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}"
      `thor member:add --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}`
    end

    members_to_remove = dest_members - src_members
    members_to_remove.each do |member|
      puts "thor member:remove --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}"
      `thor member:remove --user=#{member} --organization=#{dest_org} --team=#{dest_team.name}`
    end

  end

end
