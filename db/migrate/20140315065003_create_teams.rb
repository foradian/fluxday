class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :code
      t.text :description
      t.integer :project_id
      t.integer :members_count, :default=>0
      t.integer :managers_count, :default=>0
      t.boolean :is_deleted, :default=>false
      t.integer :pending_tasks
      t.string :status,:default=>'active'

      t.timestamps
    end
  end
end
