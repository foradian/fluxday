class TaskAssignee < ActiveRecord::Base
  belong_to :task
  belong_to :assignee,:polymorphic=>true
end
