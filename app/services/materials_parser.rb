class MaterialsParser
  
  def initialize(params)
    @file = params[:file]
  end
  
  def load_data
    return OpenStruct.new(success?: false, errors: I18n.t('.nofile')) if @file.path.nil?
    workbook = RubyXL::Parser.parse(@file.path)
    worksheet = workbook.worksheets[0]
    if isvalidfile?(worksheet)
      worksheet.each do |row|
        next if not_material?(row)
        product_model = Product.new
        product_model.material_id = evaluate_material(row)
        product_model.brand_id = evaluate_brand(row)
        product_model.measure_unit_id = evaluate_measure_unit(row)
        price_model = Price.new
        price_model.product_id = evalute_product(product_model,row)
        update_price(price_model, row)
      end
      @file.unlink
      return OpenStruct.new(success?: true, errors: I18n.t('.noformat'))
    else
      return OpenStruct.new(success?: false, errors: I18n.t('.noformat'))
    end
  end

  def isvalidfile?(worksheet)
    worksheet[2].cells.length == 6
  end

  def not_material?(row)
    row.cells[2].blank? || row.cells[2].value.blank? || row.cells[2].value.downcase == 'nombre'
  end

  def not_code?(str)
    !str.to_s.match(/^LMX-\d{5,8}/)
  end

  # Verify if a material exist, if not: create, and assign id
  def evaluate_material(row)
    material_name = row.cells[2].value.gsub(/\s\s+/,' ').gsub(/^\s|\s$/,'')
    material_description = ""
    if !(row.cells[3].blank? || row.cells[3].value.blank?)
      material_description = row.cells[3].value.gsub(/\s\s+/,' ').gsub(/^\s|\s$/,'')
    end
    material = Material.find_by([
      "lower(name) = ? AND lower(description) = ?",
      material_name.downcase,
      material_description.downcase
    ])
    return material.id if material

    material_model = Material.new
    material_model.name = material_name
    material_model.description = material_description
    material_model.save
    material_model.id
  end

  # Verify if brand is nil, exist or is new, and assign id
  def evaluate_brand(row)
    if row.cells[1].blank? || row.cells[1].value.blank?
      return 1
    else
      brand_name = row.cells[1].value.gsub(/\s\s+/,' ').gsub(/^\s|\s$/,'')
      if Brand.exists?(["lower(name) = ?",brand_name.downcase])
        return Brand.ci_find('name', brand_name.downcase).id 
      else
        brand_model = Brand.new
        brand_model.name = row.cells[1].value
        brand_model.save
        return brand_model.id
      end
    end
  end

   # Verify if measure unit is nil, exist or is new, and assign id
  def evaluate_measure_unit(row)
    
    if row.cells[4].blank? || row.cells[4].value.blank?
      return MeasureUnit.ci_find('name', "unidad").id
    else
      unit_name = row.cells[4].value.gsub(/\s\s+/,' ').gsub(/^\s|\s$/,'')
      if MeasureUnit.exists?(["lower(name) = ?", unit_name.downcase])
        return MeasureUnit.ci_find('name', unit_name).id
      else
        measure_model = MeasureUnit.new
        measure_model.name = row.cells[4].value
        measure_model.save
        return measure_model.id
      end
    end
  end

  # Verify if product exist, if not create , and assign id
  def evalute_product(product_model,row)
    if row.cells[0].blank? || row.cells[0].value.blank?
      if Product.exists?(material_id: product_model.material_id,brand_id: product_model.brand_id,measure_unit_id: product_model.measure_unit_id)
        return Product.find_by(material_id: product_model.material_id,brand_id: product_model.brand_id,measure_unit_id: product_model.measure_unit_id).id
      end
      product_model.code = Product.generate_next_code
      product_model.save
      return product_model.id
    elsif Product.exists?(code: row.cells[0].value)
      if Product.exists?(code: row.cells[0].value, material_id: product_model.material_id)
        return Product.find_by(code: row.cells[0].value).id
      else
        return nil
      end
    else
      product_model.code = row.cells[0].value
      product_model.save
      return product_model.id
    end
  end

  # Soft delete of prices and add new price to exist product
  def update_price(price_model, row)
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
