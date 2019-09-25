class Client < ApplicationRecord
  acts_as_paranoid
  has_many :quotations
  validates :name, presence: true
  paginates_per 10
end
