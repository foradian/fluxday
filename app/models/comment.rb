class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :polymorphic=>true
  scope :active, -> {where(is_deleted: false)}
end
