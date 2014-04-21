class OauthApplication < ActiveRecord::Base
  has_many :user_oauth_applications
  has_many :users, :through => :user_oauth_applications
end
