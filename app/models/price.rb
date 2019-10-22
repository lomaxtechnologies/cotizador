class Price < ApplicationRecord
  acts_as_paranoid
  belongs_to :product
  paginates_per 10

end
