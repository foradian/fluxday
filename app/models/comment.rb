class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, :polymorphic=>true
  scope :active, -> {where(is_deleted: false)}

  after_save :update_comment_count

  def update_comment_count
    source.update_attributes(:comments_count=>source.comments.count)
  end
end
