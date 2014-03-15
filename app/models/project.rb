class Project < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  has_many :teams
  has_many :project_managers
  has_many :users,:through=>:project_managers
end
