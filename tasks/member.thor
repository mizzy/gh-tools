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

end
