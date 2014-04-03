class Okr < ActiveRecord::Base
  belongs_to :user
  has_many :objectives
  has_many :key_results, :through =>:objectives
  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:name].blank? },allow_destroy: true

  scope :active, -> { where(is_deleted: false) }
end
