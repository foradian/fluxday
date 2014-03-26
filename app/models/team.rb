class Team < ActiveRecord::Base
  belongs_to :project
  has_many :team_members
  has_many :tasks
  has_many :users, :through=>:team_members
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember'
  has_many :team_leads, :through=>:leads, :source=>:user #,:foreign_key=>'user_id'
  has_many :members, -> {uniq}, :through=>:team_members, :source=>:user

  scope :active, -> {where(status: 'active')}

  after_save :update_project_team_count

  def update_project_team_count
    project.update_attributes(:team_count=>project.teams.active.count)
  end

  def self.for_user(user)
    teams = (user.teams + user.admin_teams).uniq
  end
end
