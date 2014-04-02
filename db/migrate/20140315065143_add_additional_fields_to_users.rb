class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :employee_code, :string
    add_column :users, :joining_date, :datetime
    add_column :users, :role, :string
    add_column :users, :status, :string,:default=>'active'
  end
end
