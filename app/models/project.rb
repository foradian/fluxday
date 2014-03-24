class Project < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_many :teams
  has_many :tasks
  has_many :project_managers
  has_many :users,:through=>:project_managers
  has_many :team_members, :through => :teams
  has_many :project_members, :through=>:team_members, :source=>:user
  scope :active, -> {where(is_deleted: false)}

  #after_save  :update_numbers

  def members
    return project_members.active.uniq
  end

  def update_numbers
    update_attributes(:team_count=>self.teams.count)
  end
end
