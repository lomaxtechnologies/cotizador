class Product < ApplicationRecord
  belongs_to :material
  belongs_to :brand
  belongs_to :measure_unit
  has_one :price
  has_many :quotation_products
  has_many :comments, as: :commentable
end
