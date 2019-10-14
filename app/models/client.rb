class Client < ApplicationRecord
  acts_as_paranoid
  has_many :quotations
  validates :name, presence: true
  paginates_per 10

  # Returns all the clients, but only the id, name and nit fields
  scope :all_only_indentifier_fields, -> {select(:id, :name, :nit).all}
end
