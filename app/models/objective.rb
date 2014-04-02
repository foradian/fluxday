class Objective < ActiveRecord::Base
  belongs_to :user
  has_many :key_results
  has_many :tasks,:through=>:key_results
  accepts_nested_attributes_for :key_results, allow_destroy: true

  scope :active, -> { where(is_deleted: false) }
end
