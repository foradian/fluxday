class Team < ActiveRecord::Base
  belongs_to :project
  has_many :team_members
  has_many :users, :through=>:team_members
  has_many :leads, :class_name=>'TeamMember', :conditions => { :role => 'lead' }
  has_many :team_leads, :through=>:leads, :source=>:user #,:foreign_key=>'user_id'
  scope :active, where('is_deleted = ?',false)
end
