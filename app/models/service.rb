class Service < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  validates :creation_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :actual_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  paginates_per 10

  def save
    if self.name_changed?
      if Service.exists?(name: name)
        errors.add(:name, :duplicated)
        false
      else
        if new_record?
          self.actual_price = creation_price
        end
        super
      end
    else
      super
    end
  end
end
