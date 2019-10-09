class Brand < ApplicationRecord
  acts_as_paranoid
  has_many :products
  validates :name, presence: true, uniqueness: true
  paginates_per 10

  def save
  if self.name_changed?
    if Brand.exists?(name: name)
      errors.add(:name, :duplicated)
      false
    else
      super
    end
  else
    super
  end
end
end
