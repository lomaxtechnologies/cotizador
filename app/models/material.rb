class Material < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true
  paginates_per 10
end
