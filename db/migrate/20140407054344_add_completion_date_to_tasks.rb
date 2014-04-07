class AddCompletionDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed_on, :datetime
  end
end
