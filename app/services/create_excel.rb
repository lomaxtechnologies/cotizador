require 'rubyXL/convenience_methods'

class CreateExcel
  def initialize(params)
    @quotation_id = params[:id]
    @quotation = Quotation.find(@quotation_id)
    @detail = @quotation.detailed_info
  end
    
  def create
    code =@quotation_id.to_i + 100
    filename_path ="storage/"+@quotation.quotation_date.to_s.gsub(/-/,'')+"-"+code.to_s+"-"+@detail[:client].name+".xlsx"
    
    path = 'storage/plantilla_simple.xlsx'
    if @quotation.quotation_type == 't_comparative'
      path = 'storage/plantilla_comparativa.xlsx'
    end
    
    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = @detail[:client].name
    products = @detail[:quotation_products]
    totals_products = @detail[:products_totals]
    if @quotation.quotation_type == 't_comparative'
      addProductsComparative(worksheet,products)
    elsif @quotation.quotation_type == 't_simple'
      addProductsSimple(worksheet,products)
    else
      deleteBrandRow(worksheet)
      addProductsBrand(worksheet,products)
    end
    workbook.write(filename_path)
  end

  def deleteBrandRow(worksheet)
    worksheet.delete_column(2)
  end
  
  def addProductsSimple(worksheet,products)
    cont = 1
    products.each do |product|
      worksheet[cont][0].change_contents(product['amount'].to_i) 
      worksheet[cont][1].change_contents(product[:material].to_s) 
      worksheet[cont][2].change_contents(product[:brand].to_s) 
      worksheet[cont][3].change_contents(product[:t_simple_price].to_d) 
      worksheet[cont][4].change_contents(product[:t_simple_total].to_d) 
      worksheet[cont][5].change_contents(product[:t_simple_price_with_percent].to_d) 
      worksheet[cont][6].change_contents(product[:t_simple_total_with_percent].to_d) 
      cont = cont+1
      worksheet.insert_row(cont)
    end
  end

  def addProductsBrand(worksheet,products)
    cont = 1
    products.each do |product|
      p product
      worksheet[cont][0].change_contents(product['amount'].to_i) 
      worksheet[cont][1].change_contents(product[:material].to_s)
      if @quotation.quotation_type == 't_supranet_only'
        worksheet[cont][2].change_contents(product[:t_supranet_only_price].to_d) 
        worksheet[cont][3].change_contents(product[:t_supranet_only_total].to_d) 
        worksheet[cont][4].change_contents(product[:t_supranet_only_price_with_percent].to_d) 
        worksheet[cont][5].change_contents(product[:t_supranet_only_total_with_percent].to_d) 
      else
        worksheet[cont][2].change_contents(product[:t_siemon_only_price].to_d) 
        worksheet[cont][3].change_contents(product[:t_siemon_only_total].to_d) 
        worksheet[cont][4].change_contents(product[:t_siemon_only_price_with_percent].to_d) 
        worksheet[cont][5].change_contents(product[:t_siemon_only_total_with_percent].to_d) 
      end
      cont = cont+1
      worksheet.insert_row(cont)
    end
  end
  
  def addProductsComparative(worksheet, products)
    cont = 1
    products.each do |product|
      worksheet[cont][0].change_contents(product['amount'].to_i) 
      worksheet[cont][1].change_contents(product['material'].to_s) 
      worksheet[cont][2].change_contents(product['t_supranet_only_price'].to_d) 
      worksheet[cont][3].change_contents(product['t_siemon_only_price'].to_d) 
      worksheet[cont][4].change_contents(product['t_supranet_only_total'].to_d) 
      worksheet[cont][5].change_contents(product['t_siemon_only_total'].to_d) 
      worksheet[cont][6].change_contents(product['t_supranet_only_price_with_percent'].to_d) 
      worksheet[cont][7].change_contents(product['t_siemon_only_price_with_percent'].to_d) 
      worksheet[cont][8].change_contents(product['t_supranet_only_total_with_percent'].to_d) 
      worksheet[cont][9].change_contents(product['t_siemon_only_total_with_percent'].to_d) 
      cont = cont+1
      worksheet.insert_row(cont)
    end
  end
  
  def addProductsTotal(worksheet,totals_products)
  end

end