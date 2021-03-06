class ProductsController < ApplicationController
  layout 'manager'
  before_action :set_product, only: %i[update destroy]

  def index
    @search = Product.ransack(search_params)
    @products = @search.result.includes(:material, :price).order(code: 'asc')
    @page_size = params.fetch(:page_size, 10)
    @products = @products.page(params[:page]).per(@page_size)
  end

  def new
    @product = Product.new
    @product.code = Product.generate_next_code
    @product.price = Price.new
  end

  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        notice = t('.success')
        format.html { redirect_to products_path, notice: notice}
      else
        alert = @product.errors.full_messages.join('.')
        format.html { redirect_to new_product_path, alert: alert}
      end
    end
  end

  def update
    respond_to do |format|
      # This destroy is a soft delete, so we can keep track of the currend and old prices
      @product.price.destroy
      @product.build_price(price_params)
      if @product.errors.any?
        alert = @product.errors.full_messages.join('.')
        format.html { redirect_to products_url, alert: alert }
      end
      if @product.save
        notice = t('.update')
        format.html { redirect_to products_url, notice: notice }
      else
        alert = @product.errors.full_messages.join('.')
        format.html { redirect_to products_url, alert: alert }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      notice = t('.destroy')
      format.html { redirect_to products_url, notice: notice }
    end
  end

  def download_price
    workbook = CreateExcelProducts.new().create
    filename = "#{t('.filename_prefix')}#{Date.today.to_s}.xlsx"
    return send_data workbook, filename: filename, type: 'application/excel', disposition: 'inline'
  end

  def api_upload
    file = CreateTmp.new(src: params[:csv_file],name: 'upload',ext: '.xlsx').create
    @result = MaterialsParser.new(file: file).load_data
    response_with_success
  end

  # API For prices controller
  # GET /prices/api/get-products

  def api_simple
    search = params.fetch(:search, "").split
    query = ""

    search.each do |str|
      if query.empty?
        query += "(lower(materials.name) like '%#{str}%' OR lower(brands.name) like '%#{str}%' OR lower(materials.description) like '%#{str}%')"
      else
        query += "AND (lower(materials.name) like '%#{str}%' OR lower(brands.name) like '%#{str}%' OR lower(materials.description) like '%#{str}%')"
      end
    end

    products = Product.fields_for_simple.where(query).map do |product|
      product.attributes
    end

    response_with_success(products)
  end


  def api_per_brand
    products = ""
    if params[:quotation_type] == "t_supranet_only"
      products = Product.fields_for_supranet
    else 
      products = Product.fields_for_siemon
    end
    
    search = params.fetch(:search, "").split
    query = ""

    search.each do |str|
      if query.empty?
        query += "(lower(materials.name) like '%#{str}%' OR lower(materials.description) like '%#{str}%')"
      else
        query += "AND (lower(materials.name) like '%#{str}%' OR lower(materials.description) like '%#{str}%')"
      end
    end
    products = products.where(query).map do |product|
      product.attributes
    end

    response_with_success(products)
  end

  def products_by_material
    return response_with_error(t('.errors.unespecified_material')) unless params[:material_id]
    data = Product.find_by_material(params[:material_id])
    return response_with_error(t('.errors.material_not_found')) unless data
    response_with_success(data)
  end

  private

  def search_params
    params.fetch(:q, {}).permit(:code_cont, :material_name_cont)
  end

  def product_params
    params.require(:product).permit(
      :material_id, 
      :brand_id, 
      :measure_unit_id, 
      :code, 
      price_attributes: %i[product_price])
  end

  def price_params
    params.require(:price).permit(:product_price)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
