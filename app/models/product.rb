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

      Material.only_deleted.where(id: material_id).first
    when :brand
      return brand if brand

      Brand.only_deleted.where(id: brand_id).first
    when :measure_unit
      return measure_unit if measure_unit

      MeasureUnit.only_deleted.where(id: measure_unit_id).first
    end
  end
end
