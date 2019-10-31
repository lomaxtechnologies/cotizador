class Service < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  has_many :quotation_services
  paginates_per 10

  # Returns all the services, but only the id, name description and price
  scope :fields_for_quotation, -> {
    select(:id, "concat(name, ' ', description) as name", :price).all.order(name: 'asc',description: 'asc')
  }

  def save
    if name_changed? && Service.exists?(name: name, deleted_at: nil)
      errors.add(:name, :duplicated)
      return false
    end
    super
  end

  def update(params)
    new_service = dup
    destroy
    new_service.assign_attributes(params)
    new_service.save
  end

  def update_column(column, value)
    params = {}
    params[column] = value
    self.update(params)
  end
end
