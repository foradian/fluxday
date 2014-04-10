class AddApprovalToOkrs < ActiveRecord::Migration
  def change
    add_column :okrs, :approved, :boolean,:default=>false
  end
end
