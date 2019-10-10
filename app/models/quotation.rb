class Quotation < ApplicationRecord
  acts_as_paranoid
  belongs_to :client
  belongs_to :user
  has_many :quotation_products
  has_many :quotation_services
  has_many :attachments
  has_many :quotations_notes
  has_many :comments, as: :commentable

  def self.add_comment (params,user)
    comment = Comment.new
    comment.user_id = user.id
    comment.note = params[:comments].note
    comment.save
  end
end
