class CreateExcel
  def initialize(params)
    @quotation_id = params[:id]
    @quotation = Quotation.find(@quotation_id)
    @detail = @quotation.detailed_info
  end
    
  def create
    path = 'storage/platialla_simple.xlsx'
    path = 'storage/plantilla_comparativa.xlsx' if @quotation.quotation_type == 't_comparative'
    code =@quotation_id.to_i + 100
    filename_path ="storage/"+@quotation.quotation_date.to_s.gsub(/-/,'')+"-"+code.to_s+"-"+@detail[:client].name+".xlsx"
    #workbook = RubyXL::Parser.parse(path)
    workbook = RubyXL::Workbook.new
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = @detail[:client].name
    products = @detail[:quotation_products]
    cont = 1
    products.each do |product|
      p product
      p product[:amount].to_i
      worksheet.add_cell(cont,0, product[:amount].to_i)
      worksheet.add_cell(cont,1, product[:material].to_s)
      cont = cont+1
    end
    #worksheet.insert_column(1)
    #worksheet[1][0] = 'Probando'
    workbook.write(filename_path)
    

  end

end