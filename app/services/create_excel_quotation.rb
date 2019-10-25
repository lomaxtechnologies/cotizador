require 'rubyXL/convenience_methods'

class CreateExcelQuotation
  def initialize(params)
    @quotation_id = params[:id]
    @quotation = Quotation.find(@quotation_id)
    @detail = @quotation.detailed_info
    @cont = 1
  end
    
  def create
    code =@quotation_id.to_i + 100
    filename_path ="storage/"+@quotation.quotation_date.to_s.gsub(/-/,'')+"-"+code.to_s+"-"+@detail[:client].name+".xlsx"
    filename = @quotation.quotation_date.to_s.gsub(/-/,'')+"-"+code.to_s+"-"+@detail[:client].name+".xlsx"
    path = 'storage/plantilla_simple.xlsx'
    if @quotation.quotation_type == 't_comparative'
      path = 'storage/plantilla_comparativa.xlsx'
    end
    
    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = @detail[:client].name
    #Parse data in @detail
    products = @detail[:quotation_products]
    products_totals = @detail[:products_totals]
    services = @detail[:quotation_services]
    services_totals = @detail[:services_totals]
    p services_totals
    if @quotation.quotation_type == 't_comparative'
      addProductsComparative(worksheet,products)
      addProductsTotal(worksheet,products_totals)
      addServicesComparative(worksheet,services)
      addResumeTotals(worksheet,products_totals,services_totals)
    elsif @quotation.quotation_type == 't_simple'
      addProductsSimple(worksheet,products)
      addProductsTotal(worksheet,products_totals)
      addServicesSimple(worksheet,services)
    else
      deleteBrandRow(worksheet)
      addProductsBrand(worksheet,products)
      addProductsTotal(worksheet,products_totals)
      addServicesSimple(worksheet,services)
    end
    workbook.write(filename_path)
    #send_data workbook.stream.string, filename: filename, disposition: 'attachment'
    return filename
  end

  def deleteBrandRow(worksheet)
    worksheet.delete_column(2)
    if @quotation_type == 't_supranet_only'
      worksheet[0][3].change_contents('Total Supranet')
      worksheet[0][4].change_contents('(+)% Supranet')
      worksheet[0][5].change_contents('Total Supranet')
    else
      worksheet[0][3].change_contents('Total Siemon')
      worksheet[0][4].change_contents('(+)% Siemon')
      worksheet[0][5].change_contents('Total Siemon')
    end
  end
  
  def addProductsSimple(worksheet,products)
    products.each do |product|
      worksheet[@cont][0].change_contents(product['amount'].to_i) 
      worksheet[@cont][1].change_contents(product[:material].to_s) 
      worksheet[@cont][2].change_contents(product[:brand].to_s) 
      worksheet[@cont][3].change_contents(product[:t_simple_price].to_d) 
      worksheet[@cont][4].change_contents(product[:t_simple_total].to_d) 
      worksheet[@cont][5].change_contents(product[:t_simple_price_with_percent].to_d) 
      worksheet[@cont][6].change_contents(product[:t_simple_total_with_percent].to_d) 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end

  def addProductsBrand(worksheet,products)
    products.each do |product|
      worksheet[@cont][0].change_contents(product['amount'].to_i) 
      worksheet[@cont][1].change_contents(product[:material].to_s)
      if @quotation.quotation_type == 't_supranet_only'
        worksheet[@cont][2].change_contents(product[:t_supranet_only_price].to_d) 
        worksheet[@cont][3].change_contents(product[:t_supranet_only_total].to_d) 
        worksheet[@cont][4].change_contents(product[:t_supranet_only_price_with_percent].to_d) 
        worksheet[@cont][5].change_contents(product[:t_supranet_only_total_with_percent].to_d) 
      else
        worksheet[@cont][2].change_contents(product[:t_siemon_only_price].to_d) 
        worksheet[@cont][3].change_contents(product[:t_siemon_only_total].to_d) 
        worksheet[@cont][4].change_contents(product[:t_siemon_only_price_with_percent].to_d) 
        worksheet[@cont][5].change_contents(product[:t_siemon_only_total_with_percent].to_d) 
      end
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end
  
  def addProductsComparative(worksheet, products)
    products.each do |product|
      worksheet[@cont][0].change_contents(product['amount'].to_i) 
      worksheet[@cont][1].change_contents(product['material'].to_s) 
      worksheet[@cont][2].change_contents(product['t_supranet_only_price'].to_d) 
      worksheet[@cont][3].change_contents(product['t_siemon_only_price'].to_d) 
      worksheet[@cont][4].change_contents(product['t_supranet_only_total'].to_d) 
      worksheet[@cont][5].change_contents(product['t_siemon_only_total'].to_d) 
      worksheet[@cont][6].change_contents(product['t_supranet_only_price_with_percent'].to_d) 
      worksheet[@cont][7].change_contents(product['t_siemon_only_price_with_percent'].to_d) 
      worksheet[@cont][8].change_contents(product['t_supranet_only_total_with_percent'].to_d) 
      worksheet[@cont][9].change_contents(product['t_siemon_only_total_with_percent'].to_d) 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end
  
  def addProductsTotal(worksheet,products_totals)
    if @quotation.quotation_type == 't_comparative'
      worksheet[@cont][4].change_contents(products_totals['t_supranet_only'][:without_percent].to_d)
      worksheet[@cont][5].change_contents(products_totals['t_siemon_only'][:without_percent].to_d)
      worksheet[@cont][8].change_contents(products_totals['t_supranet_only'][:with_percent].to_d)
      worksheet[@cont][9].change_contents(products_totals['t_siemon_only'][:with_percent].to_d)
    elsif @quotation.quotation_type == 't_comparative'
      worksheet[@cont][4].change_contents(products_totals[:without_percent].to_d)
      worksheet[@cont][6].change_contents(products_totals[:with_percent].to_d)
    else
      worksheet[@cont][3].change_contents(products_totals[:without_percent].to_d)
      worksheet[@cont][5].change_contents(products_totals[:with_percent].to_d)
    end
    @cont = @cont+5
  end

  def addServicesComparative(worksheet,services)
    services.each do |service|
      worksheet[@cont][0].change_contents(service[:amount].to_i) 
      worksheet[@cont][1].change_contents(service[:service].to_s) 
      worksheet[@cont][2].change_contents(service[:price_with_percent].to_d) 
      worksheet[@cont][3].change_contents(service[:total_with_percent].to_d) 
      worksheet[@cont][4].change_contents(service[:total_with_percent].to_d)
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end
  
  def addServicesSimple(worksheet,services)
    services.each do |service|
      worksheet[@cont][0].change_contents(service[:amount].to_i) 
      worksheet[@cont][1].change_contents(service[:service].to_s) 
      worksheet[@cont][2].change_contents(service[:price_with_percent].to_d) 
      worksheet[@cont][3].change_contents(service[:total_with_percent].to_d) 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end

  def addResumeTotals(worksheet,products_totals, services_totals)
    if @quotation.quotation_type == 't_comparative'
      general_total_supranet = products_totals['t_supranet_only'][:with_percent].to_d + services_totals[:with_percent].to_d
      general_total_siemon = products_totals['t_siemon_only'][:with_percent].to_d + services_totals[:with_percent].to_d
      worksheet[@cont][3].change_contents(products_totals['t_supranet_only'][:with_percent].to_d)
      worksheet[@cont][4].change_contents(products_totals['t_siemon_only'][:with_percent].to_d)
      @cont = @cont + 1
      worksheet[@cont][3].change_contents(services_totals[:with_percent].to_d)
      worksheet[@cont][4].change_contents(services_totals[:with_percent].to_d)
      @cont = @cont + 1
      worksheet[@cont][3].change_contents(general_total_supranet)
      worksheet[@cont][4].change_contents(general_total_siemon)
    else
    end
  end
end