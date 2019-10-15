class Quotation < ApplicationRecord
  acts_as_paranoid
  belongs_to :client
  belongs_to :user
  has_many :quotation_products
  has_many :quotation_services
  has_many :attachments
  has_many :quotations_notes
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :quotation_products
  accepts_nested_attributes_for :quotation_services

  paginates_per 10

  def save
    super
    update_column(:code, 100 + id) unless code.present?
  end

  def self.add_comment (params,user)
    comment = Comment.new
    comment.user_id = user.id
    comment.note = params[:comments].note
    comment.save
  end
end
