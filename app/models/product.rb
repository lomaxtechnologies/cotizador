class Product < ApplicationRecord
  acts_as_paranoid
  belongs_to :material
  belongs_to :brand, optional: true
  belongs_to :measure_unit
  has_one :price
  has_many :quotation_products
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :price, allow_destroy: true
  paginates_per 10

  def find_even_if_deleted(tag)
    case tag
    when :material
      return material if material

      Material.with_deleted.find(material_id)
    when :brand
      return brand if brand

      Brand.with_deleted.find(brand_id)
    when :measure_unit
      return measure_unit if measure_unit

      MeasureUnit.with_deleted.find(measure_unit_id)
    end
  end
end
