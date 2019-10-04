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
        next if not_code?(row.cells[0].value)
        productModel = Product.new
        productModel.material_id = evaluate_material(row)
        productModel.brand_id = evaluate_brand(row)
        productModel.measure_unit_id = evaluate_measure_unit(row)
        priceModel = Price.new
        priceModel.product_id = evalute_product(productModel)
        update_price(priceModel,row)
      end
      return OpenStruct.new(success?: true, errors: nil)
    else
      return OpenStruct.new(success?: false, errors: I18n.t('.noformat'))
    end
  end

  def isvalidfile?(worksheet)
    worksheet[2].cells.length == 6
  end

  def not_code?(str)
    !str.to_s.match(/^LMX-\d{5,8}/)
  end

  # Verify if a material exist, if not: create, and assign id
  def evaluate_material(row)
    if  Material.exists?(code: row.cells[0].value)
      return Material.find_by(code: row.cells[0].value).id
    else
      materialModel = Material.new
      materialModel.code = row.cells[0].value
      materialModel.name = row.cells[2].value
      materialModel.description = row.cells[3].nil? ? "" : row.cells[3].value
      materialModel.save
      return materialModel.id
    end
  end

  # Verify if brand is nil, exist or is new, and assign id
  def evaluate_brand(row)
    if row.cells[1].blank? || row.cells[1].value.blank?
      return 1
    elsif Brand.exists?(["lower(name) = ?", row.cells[1].value.downcase.strip])
      return Brand.find_by(["lower(name) = ?", row.cells[1].value.downcase.strip]).id 
    else
      brandModel = Brand.new
      brandModel.name = row.cells[1].value
      brandModel.save
      return brandModel.id
    end
  end

   # Verify if measure unit is nil, exist or is new, and assign id
  def evaluate_measure_unit(row)
    if row.cells[4].blank? || row.cells[4].value.blank?
      return MeasureUnit.find_by(["lower(name) = ?", "Unidad".value.downcase.strip]).id
    elsif MeasureUnit.exists?(["lower(name) = ?", row.cells[4].value.downcase.strip])
      return MeasureUnit.find_by(["lower(name) = ?", row.cells[4].value.downcase.strip]).id
    else
      measureModel = MeasureUnit.new
      measureModel.name = row.cells[4].value
      measureModel.save
      return measureModel.id
    end
  end

  # Verify if product exist, if not create, and assign id
  def evalute_product(productModel)
    if Product.exists?(material_id: productModel.material_id, measure_unit_id: productModel.measure_unit_id,brand_id: productModel.brand_id)
      return Product.find_by(material_id: productModel.material_id, measure_unit_id: productModel.measure_unit_id,brand_id: productModel.brand_id).id
    else
      productModel.save
      return productModel.id
    end
  end

  # Soft delete of prices and add new price to exist product
  def update_price(priceModel,row)
    if Price.exists?(product_id: priceModel.product_id)
      Price.destroy_by(product_id: priceModel.product_id) 
    end
    priceModel.prices = row.cells[5].value.to_s.gsub(/[^\d^\.]/,'').to_f
    priceModel.save
  end
end
