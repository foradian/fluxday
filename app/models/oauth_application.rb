class OauthApplication < ActiveRecord::Base
  has_many :user_oauth_applications
  has_many :users, :through => :user_oauth_applications
  scope :by_name, -> { order("oauth_applications.name ASC") }
end
