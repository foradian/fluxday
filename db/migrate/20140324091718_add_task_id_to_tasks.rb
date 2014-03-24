class AddTaskIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_id, :integer
  end
end
