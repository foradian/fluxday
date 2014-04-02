class AddActiveStatusToMissing < ActiveRecord::Migration
  def change
    add_column  :reporting_managers, :status, :string, :default=>'active'
    add_column  :task_assignees, :status, :string, :default=>'active'
  end
end
