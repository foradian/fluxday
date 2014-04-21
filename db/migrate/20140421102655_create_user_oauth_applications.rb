class CreateUserOauthApplications < ActiveRecord::Migration
  def change
    create_table :user_oauth_applications do |t|
      t.belongs_to :user, index: true
      t.belongs_to :oauth_application, index: true

      t.timestamps
    end
  end
end
