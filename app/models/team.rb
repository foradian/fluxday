class Team < ActiveRecord::Base
  belongs_to :project
  has_many :team_members
  has_many :users, :through=>:team_members
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember'
  has_many :team_leads, :through=>:leads, :source=>:user #,:foreign_key=>'user_id'
  has_many :members, -> {uniq}, :through=>:team_members, :source=>:user
  scope :active, -> {where(is_deleted: false)}
end
