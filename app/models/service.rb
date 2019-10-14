class Service < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  validates :creation_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :actual_price, presence: true, numericality: {greater_than_or_equal_to: 0}
  paginates_per 10

  # Returns all the services, but only the id, name description and actual_price
  scope :all_only_indentifier_fields, -> {select(:id, :name, :description, :actual_price).all}

  def save
    self.actual_price = creation_price if new_record?
    if name_changed? && Service.exists?(name: name, deleted_at: nil)
      errors.add(:name, :duplicated)
      return false
    end
    super
  end
end
