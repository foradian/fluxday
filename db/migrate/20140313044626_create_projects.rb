class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :code
      t.text :description
      t.boolean :is_deleted, :default=>false

      t.timestamps
    end
  end
end
