class Project < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_many :teams
  has_many :tasks
  has_many :project_managers
  has_many :users,:through=>:project_managers,:after_remove => :update_user_project_count
  has_many :team_members, :through => :teams
  has_many :project_members, :through=>:team_members, :source=>:user
  scope :active, -> {where(is_deleted: false)}

  validates_presence_of :name, :code
  validates_uniqueness_of :code

  #default_scope where(is_deleted: false)
  default_scope{ order("projects.name ASC")}

  #after_save  :update_numbers

  def members
    return project_members.active.uniq
  end

  def update_user_project_count(pm)
    pm.update_attributes(:admin_projects_count=>pm.projects.count)
  end

  def update_numbers
    update_attributes(:team_count=>self.teams.count)
  end

  def destroy
    if self.update_attribute(:is_deleted, true)
      self.teams.update_all(:is_deleted => true)
      self.teams.update_all(:is_deleted => true)
      self.tasks.update_all(:is_deleted => true)
      self.team_members.update_all(:status => 'archived')
      self.project_managers.update_all(:status => 'archived')
    end
  end
end
