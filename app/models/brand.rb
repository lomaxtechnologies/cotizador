class Brand < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true
  paginates_per 10

  def duplicated?
    Brand.where(name: name).count.positive?
  end

  def save
    if new_record? && duplicated?
      errors.add(:name, :duplicated)
      false
    else
      super
    end
  end
end
