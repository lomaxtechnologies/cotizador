class Product < ApplicationRecord
  acts_as_paranoid
  belongs_to :material
  belongs_to :brand, optional: true
  belongs_to :measure_unit
  has_one :price
  has_many :quotation_products
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :price, allow_destroy: true
  paginates_per 10

  def self.new_products
    Product.where(create_at: 30.minutes.ago)
  end
end
