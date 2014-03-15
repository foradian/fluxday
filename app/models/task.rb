class Task < ActiveRecord::Base
  belongs_to :user
  has_many :task_assignees
  has_many :comments, :as => :source
end
