class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :team_count, :integer
    add_column :projects, :member_count, :integer
    add_column :projects, :website, :string
  end
end
