class Comment < ApplicationRecord
  acts_as_paranoid
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :list, -> {select(:note, :user_id, :commentable_type, :commentable_id).all}
  scope :get_comment, -> (id) {select(:note, :user_id, :commentable_type, :commentable_id).where(id: id)}

end
