class CreateWorkLogs < ActiveRecord::Migration
  def change
    create_table :work_logs do |t|
      t.integer :user_id
      t.string :name
      t.integer :task
      t.time :start_time
      t.time :end_time
      t.date :date
      t.boolean :is_deleted,:default=>false

      t.timestamps
    end
  end
end
