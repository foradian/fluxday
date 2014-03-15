class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :code
      t.text :description
      t.integer :project_id
      t.integer :members_count
      t.integer :managers_count
      t.boolean :is_deleted
      t.integer :pending_tasks
      t.string :status

      t.timestamps
    end
  end
end
