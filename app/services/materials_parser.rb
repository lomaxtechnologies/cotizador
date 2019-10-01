require 'rubyXL/convenience_methods/workbook'
require 'rubyXL/convenience_methods/worksheet'

class MaterialsParser
  
  @imacable = false

  def initialize(params)
    @path = params[:path]
  end
  
  def charge_data
    workbook = RubyXL::Parser.parse(@path)
    worksheet = workbook.worksheets[0]
    worksheet.each do |row|
      if(row.cells[0].value=='Cable')
        @imacable = true
      else
        @imacable = false
      end
      if(code?(row.cells[0].value))
        code = row.cells[0].value
        measure_unit_id = MeasureUnit.find_by(name: 'Unidad')
        price = row.cells[2].value.to_s.gsub(/[^\d^\.]/, '').to_f
        data = row.cells[1].value.split(",")
        brand = (data[0].split(" "))[0]
        brand_id = nil
        if(!!(brand=~/Siemon/)||!!(brand=~/Supranet/))
          brand_id = Brand.find_by(name: brand)
        end
        name = data[0]
        description = row.cells[1].value
        #brand = 
        material_id = find_material(code, name, description)
        #print price
        if (@imacable)
          measure_unit_ida = MeasureUnit.find_by(name: 'Bobina')
          measure_unit_idb = MeasureUnit.find_by(name: 'Metro')
          pricem = price/305 
          product_ida = find_product(brand_id,material_id,measure_unit_ida)
          Price.create_with(prices: price).find_or_create_by(product_ida)
          product_idb = find_product(brand_id,material_id,measure_unit_idb)
          Price.create_with(prices: pricem).find_or_create_by(product_idb)
        end
        product_id = find_product(brand_id,material_id,measure_unit_id)
        #Price.create_with(prices: price).find_or_create_by(product_id)
      end
    end
  end

  def code?(str)
    !!(str =~ /^LMX-\d{5,8}/)
  end
  def find_product(brand_id,material_id,measure_id)
    return id = Product.find_or_create_by(material_id: material_id,measure_unit_id: measure_id,brand_id: brand_id)
  end
  def find_material(code,name,description)
    return id = Material.create_with(name: name, description: description).find_or_create_by(code: code) 
  end

end
