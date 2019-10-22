class Product < ApplicationRecord
  acts_as_paranoid
  belongs_to :material
  belongs_to :brand, optional: true
  belongs_to :measure_unit
  has_one :price
  has_many :quotation_products
  has_many :comments, as: :commentable
  has_one_attached :csv_file
  validates :code, presence: true

  accepts_nested_attributes_for :price, update_only: true

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

  def self.generate_next_code
    code = Product.order(code: :desc)
    if code.blank?
      code = 'LMX-00001'
    else
      code = code.first.code
      code = (code.gsub(/^LMX-0*/,'').to_i + 1).to_s
      case code.length
      when 1
        code = 'LMX-0000'+code
      when 2
        code = 'LMX-000'+code
      when 3
        code = 'LMX-00'+code
      when 4
        code = 'LMX-0'+code
      when 5
        code = 'LMX-'+code
      end
    end
  end

  # finds a material and returns all its product info: code, price, brand and measure unit
  def self.find_by_material(material_id)
    return false unless Material.exists?(material_id)

    material = Material.find(material_id)
    data = []
    material.products.order(brand_id: :desc ).each do |product|
      data.push(
        product_id: product.id,
        code: product.code,
        price: product.price.product_price,
        brand: product.brand.name,
        measure_unit: product.measure_unit.name
      )
    end
    data
  end

  def self.find_by_brand(brand_name)
    data = []
    if brand_name.blank?
      Product.all.each do |product|
        data.push(
          material_id: product.material_id,
          name: product.material.name,
          description: product.material.description,
          brand: product.brand.name
        )
      end
    else
      return false unless Brand.exists?(name: brand_name)
      brand = Brand.find_by(name: brand_name)
      brand.products.each do |product|
        data.push(
          material_id: product.material_id,
          name: product.material.name,
          description: product.material.description,
          brand: product.brand.name
        )
      end
    end
    data
  end

end
