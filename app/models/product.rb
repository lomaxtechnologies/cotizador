class Product < ApplicationRecord
  acts_as_paranoid
  belongs_to :material
  belongs_to :brand, optional: true
  belongs_to :measure_unit
  has_one :price
  has_many :quotation_products
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :price, update_only: true
  validates :code, presence: true, uniqueness: true
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

  def self.new_products
    Product.where(['created_at BETWEEN ? AND ?',10.minutes.ago,Time.now])
  end

  def self.generate_next_code
    code = Product.order(code: :desc).first.code
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
