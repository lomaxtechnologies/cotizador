class Price < ApplicationRecord
  acts_as_paranoid
  belongs_to :product
  paginates_per 10

  # finds a material and returns all its product info: code, price, brand and measure unit
  def self.find_by_material(material_id)
    return false unless Material.exists?(material_id)

    material = Material.find(material_id)
    data = []
    material.products.each do |product|
      data.push(
        code: product.code,
        price: product.price.product_price,
        brand: product.brand.name,
        measure_unit: product.measure_unit.name
      )
    end
    data
  end
end
