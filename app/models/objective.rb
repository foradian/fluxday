class Objective < ActiveRecord::Base
  belongs_to :user
  belongs_to :okr
  has_many :key_results
  has_many :tasks,:through=>:key_results
  accepts_nested_attributes_for :key_results, :reject_if => lambda { |a| a[:name].blank? },allow_destroy: true

  validates_presence_of :name

  scope :active, -> { where(is_deleted: false) }
end
