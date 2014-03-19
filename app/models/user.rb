class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :image, ImageUploader
  has_many  :project_managers
  has_many  :projects, :through=>:project_managers
  has_many  :team_members
  has_many  :teams, :through=>:team_members
  has_many  :task_assignees, :as=>:assignee
  has_many  :tasks,:through => :task_assignees
  has_many  :comments
  has_many  :reporting_managers
  has_many  :managers, :through=>:reporting_managers,:class_name=>'User'
  has_many :reporting_employees, :class_name => "ReportingManager", :foreign_key => "manager_id"
  has_many  :users, :through=>:reporting_employees,:class_name=>'User', :foreign_key => "user_id"
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable#, :registerable
  scope :active, -> {where(is_deleted: false)}
end
