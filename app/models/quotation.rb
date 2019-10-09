class Quotation < ApplicationRecord
  acts_as_paranoid
  belongs_to :client
  belongs_to :user
  has_many :quotation_products
  has_many :quotation_services
  has_many :attachments
  has_many :quotations_notes
  has_many :comments, as: :commentable

  def next_code
    max = Quotation.maximum('code')
    max ? max : 101
  end

  def default_material_percentage
    15
  end

  def default_service_percentage
    0
  end
end
