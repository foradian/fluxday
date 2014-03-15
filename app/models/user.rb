class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many  :project_managers
  has_many  :projects, :through=>:project_managers
  has_many  :team_members
  has_many  :teams, :through=>:team_members
  has_many  :task_assignees, :as=>:assignee
  has_many  :tasks,:through => :task_assignees
  has_many  :comments
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
