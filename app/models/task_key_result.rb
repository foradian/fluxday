class TaskKeyResult < ActiveRecord::Base
  belongs_to :task
  belongs_to :key_result
end
