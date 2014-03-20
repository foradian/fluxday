class CreateWorkLogs < ActiveRecord::Migration
  def change
    create_table :work_logs do |t|
      t.integer :user_id
      t.string :name
      t.integer :task
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_deleted,:default=>false

      t.timestamps
    end
  end
end
