class MeasureUnit < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true, uniqueness: true 
  paginates_per 10

 

end
