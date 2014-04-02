class KeyResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :objective
  has_many :tasks
  scope :active, -> { where(is_deleted: false) }
end
