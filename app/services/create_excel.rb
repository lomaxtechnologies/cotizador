class CreateExcel
  def initialize(params)
    @quotation_id = params[:id]
    @quotation = Quotation.find(@quotation_id)
    @detail = @quotation.detail_info
  end
    
  def create
    path = 'storage/platialla_simple.xlsx'
    path = 'storage/plantilla_comparativa.xlsx' if @quotation.quotation_type == 't_comparative'
    
    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheet[0]
    worksheet.sheet_name = 'Cliente'
    

  end

end