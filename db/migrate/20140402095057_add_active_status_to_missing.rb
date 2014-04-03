class AddActiveStatusToMissing < ActiveRecord::Migration
  def change
    add_column  :reporting_managers, :status, :string, :default=>'active'
    add_column  :task_assignees, :status, :string, :default=>'active'
    add_column  :objectives, :is_deleted, :boolean, :default=>false
    add_column  :key_results, :is_deleted, :boolean, :default=>false
  end
end
