class CreateKeyResults < ActiveRecord::Migration
  def change
    create_table :key_results do |t|
      t.text :name
      t.integer :user_id
      t.integer :objective_id
      t.integer :author_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
