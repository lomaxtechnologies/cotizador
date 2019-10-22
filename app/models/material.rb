class Material < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true
  paginates_per 10

  # Returns all the services, but only the id, name description and actual_price
  scope :fields_for_quotation, -> {select(:id, :name, :description).all}
end
