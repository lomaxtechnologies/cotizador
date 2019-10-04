class MeasureUnit < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true 
  paginates_per 10

 

end
