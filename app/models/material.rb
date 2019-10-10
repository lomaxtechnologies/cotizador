class Material < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true
  paginates_per 10

  # Returns all the services, but only the id, name description and actual_price
  scope :all_only_indentifier_fields, -> {select(:id, :name, :description).all}
end
