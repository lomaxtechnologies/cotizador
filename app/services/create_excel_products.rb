require 'rubyXL/convenience_methods'

class CreateExcelProducts
  def initialize
    @products = Product.all
  end
    
  def create
    cont = 3
    path = 'storage/templates/plantilla_precios.xlsx'
    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]
    @products.each do |product| 
      worksheet.add_cell(cont,0,product.code) 
      worksheet.add_cell(cont,1,product.brand.name) 
      worksheet.add_cell(cont,2,product.material.name) 
      worksheet.add_cell(cont,3,product.material.description)
      worksheet.add_cell(cont,4,product.measure_unit.name)
      worksheet.add_cell(cont,5,product.price.product_price)   
      cont = cont + 1 
    end
    workbook.stream.read
  end
end