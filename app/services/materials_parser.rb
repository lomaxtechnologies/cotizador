class MaterialsParser
  
  def initialize(params)
    @path = params[:path]
  end
  
  def load_data
    return OpenStruct.new(success?: false, errors: I18n.t('.nofile')) if @path.nil?
    workbook = RubyXL::Parser.parse(@path)
    worksheet = workbook.worksheets[0]
    if isvalidfile?(worksheet)
      worksheet.each do |row|
        next if not_material?
        product_model = Product.new
        product_model.material_id = evaluate_material(row)
        product_model.brand_id = evaluate_brand(row)
        product_model.measure_unit_id = evaluate_measure_unit(row)
        price_model = Price.new
        price_model.product_id = evalute_product(product_model)
        update_price(price_model,row)
      end
      return OpenStruct.new(success?: true, errors: nil)
    else
      return OpenStruct.new(success?: false, errors: I18n.t('.noformat'))
    end
  end

  def isvalidfile?(worksheet)
    worksheet[2].cells.length == 6
  end

  def not_material?(row)
    row.cells[2].blank? || row.cells[2].value.blank?
  end
  
  def not_code?(str)
    !str.to_s.match(/^LMX-\d{5,8}/)
  end

  # Verify if a material exist, if not: create, and assign id
  def evaluate_material(row)
    if  Material.exists?(name: row.cells[2].value)
      return Material.find_by(name: row.cells[2].value).id
    else
      material_model = Material.new
      material_model.name = row.cells[2].value
      material_model.description = row.cells[3].nil? ? "" : row.cells[3].value
      material_model.save
      return material_model.id
    end
  end

  # Verify if brand is nil, exist or is new, and assign id
  def evaluate_brand(row)
    if row.cells[1].blank? || row.cells[1].value.blank?
      return 1
    elsif Brand.exists?(["lower(name) = ?", row.cells[1].value.downcase.strip])
      return Brand.find_by(["lower(name) = ?", row.cells[1].value.downcase.strip]).id 
    else
      brand_model = Brand.new
      brand_model.name = row.cells[1].value
      brand_model.save
      return brand_model.id
    end
  end

   # Verify if measure unit is nil, exist or is new, and assign id
  def evaluate_measure_unit(row)
    if row.cells[4].blank? || row.cells[4].value.blank?
      return MeasureUnit.find_by(["lower(name) = ?", "Unidad".value.downcase.strip]).id
    elsif MeasureUnit.exists?(["lower(name) = ?", row.cells[4].value.downcase.strip])
      return MeasureUnit.find_by(["lower(name) = ?", row.cells[4].value.downcase.strip]).id
    else
      measure_model = MeasureUnit.new
      measure_model.name = row.cells[4].value
      measure_model.save
      return measure_model.id
    end
  end

  # Verify if product exist, if not create , and assign id
  def evalute_product(product_model)
    if row.cells[0].blank? || row.cells[0].value.blank?
      code = Product.order(:code :desc).first.code
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
      product_model.code = code
      product_model.save
      return product_model.id
    elsif Product.exists?(code: row.cells[0].value)
      if Product.exists?(code: row.cells[0].value, material_id: product_model.material_id)
        
      end
      return Product.find_by(code: row.cells[0].value).id
    else
      product_model.code = row.cells[0].value
      product_model.save
      return product_model.id
    end
  end

  # Soft delete of prices and add new price to exist product
  def update_price(price_model,row)
    price_model.product_price = row.cells[5].value.to_s.gsub(/[^\d^\.]/,'').to_f
    if Price.exists?(product_id: price_model.product_id)
      if price_model.product_price != Price.find_by(product_id: price_model.product_id).product_price
        Price.destroy_by(product_id: price_model.product_id) 
        price_model.save        
      end
    else
      price_model.save  
    end
  end
end
