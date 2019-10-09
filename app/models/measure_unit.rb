class MeasureUnit < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true 
  paginates_per 10

  scope :ci_find, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase).first}
end
