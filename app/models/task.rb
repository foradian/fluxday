class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :project
  has_many :task_assignees
  has_many :users, :through=>:task_assignees
  has_many :comments, :as => :source

  belongs_to :root_task, :class_name => "Task", :foreign_key => "task_id"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => "task_id"

  scope :active, -> {where(is_deleted: false)}

end
