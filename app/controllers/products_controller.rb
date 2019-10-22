class ProductsController < ApplicationController
  layout 'manager'
  before_action :set_product, only: %i[update]

  def index
    @search = Product.ransack(search_params)
    @products = @search.result.includes(:material, :price).order('code ASC')
    @page_size = params.fetch(:page_size, 10)
    @products = @products.page(params[:page]).per(@page_size)      
  end

  def new
    @product = Product.new
    @product.code = Product.generate_next_code
    @product.price = Price.new
  end

  def create
    @product = Product.new(products_params)
    respond_to do |format|
      if @product.save
        notice = t('.success')
        format.html { redirect_to products_path, notice: notice}
      else
        alert = @product.errors.full_messages.join('.')
        format.html { redirect_to products_path, alert: alert}
      end
    end
  end

  def destroy
    Product.delete(params[:id])
    respond_to do |format|
      notice = t('.destroy')
      format.html { redirect_to products_url, notice: notice }
    end
  end
 
  def upload
    file = CreateTmp.new(src: params[:csv_file],name: 'upload',ext: '.xlsx').create
    active_thread = Thread.new do 
      @result = MaterialsParser.new(file: file).load_data
    end
    redirect_to products_path, notice: t('.upload')
  end

  # API For prices controller
  # GET /prices/api/get-products
  def products_by_material
    return response_with_error(t('.errors.unespecified_material')) unless params[:material_id]
    data = Product.find_by_material(params[:material_id])
    return response_with_error(t('.errors.material_not_found')) unless data
    response_with_success(data)
  end

  private

  def search_params
    params.fetch(:q, {}).permit( :code_cont, :material_name_cont)
  end

  def products_params
    params.require(:product).permit(
      :material_id, 
      :brand_id, 
      :measure_unit_id, 
      :code, 
      price_attributes: %i[product_price])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
