class Client < ApplicationRecord
  acts_as_paranoid
  has_many :quotations
  validates :name, presence: true
  paginates_per 10

  # Returns all the clients, but only the id, name and nit fields
  scope :fields_for_quotation, -> {select(:id, :name, :nit).all}
end
