require 'rubyXL/convenience_methods'

class CreateExcelQuotation
  def initialize(params)
    @quotation_id = params[:id]
    @quotation = Quotation.find(@quotation_id)
    @detail = @quotation.detailed_info
    @cont = 4
  end
    
  def create
    path = 'storage/template-simple.xlsx'
    if @quotation.quotation_type == 't_comparative'
      path = 'storage/template-comparative.xlsx'
    end
    
    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = 'Propuesta'
    products = @detail[:quotation_products]
    products_totals = @detail[:products_totals]
    services = @detail[:quotation_services]
    services_totals = @detail[:services_totals]
    if @quotation.quotation_type == 't_comparative'
      addProductsComparative(worksheet,products)
      addProductsTotal(worksheet,products_totals)
      addHeaderForOptions(worksheet)
      addServices(worksheet,services)
      addTotalOptionA(worksheet,products_totals,services_totals)
      addHeaderForOptions(worksheet)
      addServices(worksheet,services)
      addTotalOptionB(worksheet,products_totals,services_totals)
    else
      headerForBrand(worksheet)
      addProductsSimple(worksheet,products)
      addProductsTotal(worksheet,products_totals)
      addHeaderForOptions(worksheet)
      addServices(worksheet,services)
      addTotalOptionSimple(worksheet,products_totals,services_totals)
    end
    workbook.stream.read
  end
  
  def headerForBrand(worksheet)
    if @quotation.quotation_type == 't_supranet_only'
      worksheet[1][2].change_contents('Supranet')
    elsif @quotation.quotation_type == 't_siemon_only'
      worksheet[1][2].change_contents('Siemon')
    else
      worksheet[1][2].change_contents('Detalle')
    end
  end
  
  def addProductsComparative(worksheet, products)
    products.each do |product|
      worksheet.add_cell(@cont,0,product['amount'].to_i) 
      worksheet.add_cell(@cont,1,product['material'].to_s) 
      worksheet.add_cell(@cont,2,product['t_supranet_only_percent'].to_d) 
      worksheet.add_cell(@cont,3,product['t_supranet_only_price'].to_d) 
      worksheet.add_cell(@cont,4,product['t_supranet_only_total'].to_d) 
      worksheet.add_cell(@cont,5,product['t_supranet_only_price_with_percent'].to_d) 
      worksheet.add_cell(@cont,6,product['t_supranet_only_total_with_percent'].to_d) 
      worksheet.add_cell(@cont,7,product['t_siemon_only_percent'].to_d) 
      worksheet.add_cell(@cont,8,product['t_siemon_only_price'].to_d) 
      worksheet.add_cell(@cont,9,product['t_siemon_only_total'].to_d) 
      worksheet.add_cell(@cont,10,product['t_siemon_only_price_with_percent'].to_d) 
      worksheet.add_cell(@cont,11,product['t_siemon_only_total_with_percent'].to_d) 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end

  def addProductsSimple(worksheet,products)
    products.each do |product|
      worksheet.add_cell(@cont,0,product['amount'].to_i) 
      worksheet.add_cell(@cont,1,product[:material].to_s)   
      if @quotation.quotation_type == 't_siemon_only'
        worksheet.add_cell(@cont,2,product[:t_siemon_only_percent].to_d) 
        worksheet.add_cell(@cont,3,product[:t_siemon_only_price].to_d) 
        worksheet.add_cell(@cont,4,product[:t_siemon_only_total].to_d) 
        worksheet.add_cell(@cont,5,product[:t_siemon_only_price_with_percent].to_d) 
        worksheet.add_cell(@cont,6,product[:t_siemon_only_total_with_percent].to_d) 
      elsif @quotation.quotation_type == 't_supranet_only'
        worksheet.add_cell(@cont,2,product[:t_supranet_only_percent].to_d) 
        worksheet.add_cell(@cont,3,product[:t_supranet_only_price].to_d) 
        worksheet.add_cell(@cont,4,product[:t_supranet_only_total].to_d) 
        worksheet.add_cell(@cont,5,product[:t_supranet_only_total_with_percent].to_d) 
        worksheet.add_cell(@cont,6,product[:t_supranet_only_price_with_percent].to_d) 
      else
        material = product[:brand] + " - " + product[:material]
        worksheet.add_cell(@cont,1,material)   
        worksheet.add_cell(@cont,2,product[:t_simple_percent].to_d) 
        worksheet.add_cell(@cont,3,product[:t_simple_price].to_d) 
        worksheet.add_cell(@cont,4,product[:t_simple_total].to_d) 
        worksheet.add_cell(@cont,5,product[:t_simple_price_with_percent].to_d) 
        worksheet.add_cell(@cont,6,product[:t_simple_total_with_percent].to_d) 
      end 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end

  def addProductsTotal(worksheet,products_totals)
    worksheet.merge_cells(@cont,0,@cont,1)
    if @quotation.quotation_type == 't_comparative'
      worksheet[@cont][4].change_contents(products_totals['t_supranet_only'][:without_percent].to_d)
      worksheet[@cont][6].change_contents(products_totals['t_supranet_only'][:with_percent].to_d)
      worksheet[@cont][9].change_contents(products_totals['t_siemon_only'][:without_percent].to_d)
      worksheet[@cont][11].change_contents(products_totals['t_siemon_only'][:with_percent].to_d)
    else
      worksheet[@cont][4].change_contents(products_totals[:without_percent].to_d)
      worksheet[@cont][6].change_contents(products_totals[:with_percent].to_d)
    end
    @cont = @cont+3
  end

  
  def addHeaderForOptions(worksheet)
    worksheet.merge_cells(@cont,0,@cont+2,1) 
    worksheet.merge_cells(@cont,2,@cont,6) 
    @cont=@cont+1
    worksheet.merge_cells(@cont,2,@cont,6)
    if @quotation.quotation_type == 't_supranet_only'
      worksheet[@cont][2].change_contents('Supranet')
    elsif @quotation.quotation_type == 't_siemon_only'
      worksheet[@cont][2].change_contents('Siemon')
    elsif @quotation.quotation_type == 't_simple'
      worksheet[@cont][2].change_contents('Detalle') 
    end
    
    @cont=@cont+1
    worksheet.merge_cells(@cont,3,@cont,4) 
    worksheet.merge_cells(@cont,5,@cont,6) 
    @cont=@cont+2
  end

  def addServices(worksheet,services)
    services.each do |service|
      p service
      worksheet.add_cell(@cont,0,service['amount'].to_i) 
      worksheet.add_cell(@cont,1,service['service'].to_s) 
      worksheet.add_cell(@cont,2,service['percent'].to_d) 
      worksheet.add_cell(@cont,3,service[:price].to_d) 
      worksheet.add_cell(@cont,4,service[:total].to_d) 
      worksheet.add_cell(@cont,5,service[:price_with_percent].to_d) 
      worksheet.add_cell(@cont,6,service[:total_with_percent].to_d) 
      @cont = @cont+1
      worksheet.insert_row(@cont)
    end
    worksheet.delete_row(@cont)
  end

  def addTotalOptionA(worksheet,products_totals,services_totals)
    total = products_totals['t_supranet_only'][:without_percent].to_d + services_totals[:without_percent].to_d
    total_with_percent = products_totals['t_supranet_only'][:with_percent].to_d + services_totals[:with_percent].to_d
    worksheet[@cont][4].change_contents(products_totals['t_supranet_only'][:without_percent].to_d)
    worksheet[@cont][6].change_contents(products_totals['t_supranet_only'][:with_percent].to_d)
    @cont=@cont+1
    worksheet[@cont][4].change_contents(total)
    worksheet[@cont][6].change_contents(total_with_percent)
    @cont=@cont+2
  end

  def addTotalOptionB(worksheet,products_totals,services_totals)
    total = products_totals['t_siemon_only'][:without_percent].to_d + services_totals[:without_percent].to_d
    total_with_percent = products_totals['t_siemon_only'][:with_percent].to_d + services_totals[:with_percent].to_d
    worksheet[@cont][4].change_contents(products_totals['t_siemon_only'][:without_percent].to_d)
    worksheet[@cont][6].change_contents(products_totals['t_siemon_only'][:with_percent].to_d)
    @cont=@cont+1
    worksheet[@cont][4].change_contents(total)
    worksheet[@cont][6].change_contents(total_with_percent) 
  end

  def addTotalOptionSimple(worksheet,products_totals,services_totals)
    total = products_totals[:without_percent].to_d + services_totals[:without_percent].to_d
    total_with_percent = products_totals[:with_percent].to_d + services_totals[:with_percent].to_d
    worksheet[@cont][4].change_contents(products_totals[:without_percent].to_d)
    worksheet[@cont][6].change_contents(products_totals[:with_percent].to_d)
    @cont=@cont+1
    worksheet[@cont][4].change_contents(total)
    worksheet[@cont][6].change_contents(total_with_percent) 
  end 

end