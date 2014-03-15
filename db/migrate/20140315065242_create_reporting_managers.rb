class CreateReportingManagers < ActiveRecord::Migration
  def change
    create_table :reporting_managers do |t|
      t.integer :user_id
      t.integer :manager_id

      t.timestamps
    end
  end
end
