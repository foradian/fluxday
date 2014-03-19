class AddSoftDeleteFieldsToUsersTasksAndComments < ActiveRecord::Migration
  def change
    add_column :users, :is_deleted, :boolean, :default=>false
    add_column :tasks, :is_deleted, :boolean, :default=>false
    add_column :comments, :is_deleted, :boolean, :default=>false
  end
end
