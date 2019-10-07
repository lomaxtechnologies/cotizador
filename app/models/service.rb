class Service < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true, uniqueness: true
  validates :creation_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :actual_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  paginates_per 10

  def save
    if new_record?
      self.actual_price = creation_price
    end
    super
  end
end
