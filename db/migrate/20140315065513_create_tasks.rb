class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :project_id
      t.integer :team_id
      t.integer :user_id
      t.string :tracker_id
      t.integer :comments_count

      t.timestamps
    end
  end
end
