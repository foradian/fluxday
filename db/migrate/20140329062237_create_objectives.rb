class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.text :name
      t.integer :user_id
      t.integer :author_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
