class PricesController < ApplicationController
  layout "manager"
  before_action :set_product, only: %i[update]
 
  # GET /prices
  # GET /prices.json
  def index
    #@q = Product.ransack(search_prices_params)
    #@products = @q.result
    #@prooducts = @products.page(params[:page])
    @products = Product.all
    @products = @products.page(params[:page])
  end
  
  def upload

    result = MaterialsParser.new({path: params[:file]}).load_data
    if result.success?
      notice= t('.import')
      redirect_to prices_path, notice: notice
    else
      redirect_to prices_path, notice: result.errors
    end
  end

  def update
    @product = @price.product
    p @product
    @price.destroy
    price = Price.new(prices_params)
    price.save
    redirect_to prices_path, notice: "Precio actualizado"
  end


  private
    def search_prices_params
      params.fetch(:q,{}).permit(:material_id_cont)
    end

    def products_params
      params.require(:product).permit(:material_id,:brand_id,:measure_unit_id, price_attributes: [:prices])
    end
    def prices_params 
      params.require(:price).permit(:prices).merge(product: @product)
    end
    def set_product
      @price = Price.find(params[:id])
    end

end