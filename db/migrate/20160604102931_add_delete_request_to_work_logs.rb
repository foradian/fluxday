class AddDeleteRequestToWorkLogs < ActiveRecord::Migration
  def change
    add_column :work_logs, :delete_request, :boolean, :default => false
  end
end
