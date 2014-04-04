class Team < ActiveRecord::Base
  belongs_to :project
  has_many :team_members
  has_many :tasks
  has_many :users, :through=>:team_members
  has_many :okrs, :through=>:users
  has_many :key_results, :through=>:okrs
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember'
  has_many :team_leads, :through=>:leads, :source=>:user #,:foreign_key=>'user_id'
  has_many :members, -> {uniq}, :through=>:team_members, :source=>:user

  default_scope {where.not(is_deleted:true).order("name ASC")}

  scope :active, -> {where(status: 'active')}

  after_save :update_project_team_count

  def update_project_team_count
    project.update_attributes(:team_count=>project.teams.active.count)
  end

  def self.for_user(user)
    teams = Team.where(id:(user.team_ids + user.admin_team_ids).uniq)
  end

  def self.admind_by_user(user)
    teams = Team.where(id:(user.projects.collect(&:team_ids).flatten + user.admin_team_ids).uniq)
  end
end
