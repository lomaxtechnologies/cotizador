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
        #measure_unit_id = MeasureUnit.find(name: 'Unidad')
        price = row.cells[2].value.to_s.gsub(/[^\d^\.]/, '').to_f
        data = row.cells[1].value.split(",")
        #brand = 
        #material_id = find_material(code, name, description)
        #print price
        if (@imacable)
          measure_unit_ida = MeasureUnit.find(name: 'Bobina')
          measure_unit_idb = MeasureUnit.find(name: 'Metro')
          pricem = price/305 
        end
      end
    end
  end

  def code?(str)
    !!(str =~ /^LMX-\d{5,8}/)
  end

  def find_material(code,name,description)
    return id = Material.create_with(name: name, description: description).find_or_create_by(code: code) 
  end

end
