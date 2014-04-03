class CreateOkrs < ActiveRecord::Migration
  def change
    create_table :okrs do |t|
      t.integer :user_id
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :is_deleted, :default=>false

      t.timestamps
    end
  end
end
