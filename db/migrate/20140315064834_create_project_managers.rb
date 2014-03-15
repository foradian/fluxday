class CreateProjectManagers < ActiveRecord::Migration
  def change
    create_table :project_managers do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
