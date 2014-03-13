class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :code
      t.text :description
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
