class CreateTaskAssignees < ActiveRecord::Migration
  def change
    create_table :task_assignees do |t|
      t.integer :task_id
      t.string :assignee_type
      t.integer :assignee_id

      t.timestamps
    end
  end
end
