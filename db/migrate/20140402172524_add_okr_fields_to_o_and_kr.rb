class AddOkrFieldsToOAndKr < ActiveRecord::Migration
  def change
    add_column :objectives, :okr_id, :integer
  end
end
