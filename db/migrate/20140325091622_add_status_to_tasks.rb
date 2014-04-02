class AddStatusToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :status, :string, :default=>'active'
  end
end
