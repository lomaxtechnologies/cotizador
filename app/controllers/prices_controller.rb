# frozen_string_literal: true

class PricesController < ApplicationController
  layout 'manager'
  before_action :set_product, only: %i[update]

  # GET /prices
  # GET /prices.json
  def index
    @q = Product.ransack(search_prices_params)
    @products = @q.result.includes(:material, :price)
    @products = @products.page(params[:page])
  end

  def new
    @product = Product.new
    @product.price = Price.new
  end

  def create
    @product = Product.new(products_params)
    respond_to do |format|
      if @product.save
        notice = t('.success')
        format.html { redirect_to prices_path, notice: notice}
      else
        alert = @product.errors.full_messages.join('.')
        format.html { redirect_to prices_path, alert: alert}
      end
    end
  end

  def update
    @product = @price.product
    @price.destroy
    price = Price.new(prices_params)
    price.save
    redirect_to prices_path, notice: t('.update')
  end

  def destroy
    Product.delete(params[:id])
    respond_to do |format|
      notice = t('.destroy')
      format.html { redirect_to prices_url, notice: notice }
    end
  end
  
  def upload
    @result = OpenStruct.new(success?: true, errors: nil)
    active_thread = Thread.new do
      @result = MaterialsParser.new(path: params[:file]).load_data
    end
    #p active_thread.alive?
    if @result.success?
      redirect_to dashboard_prices_path, notice: t('.upload')
    else
      redirect_to prices_path, notice: @result.errors
    end
  end

  def create_excel
    CreateExcel.create
  end
  
  def dashboard
    @products = Product.new_products
  end

  private

  def search_prices_params
    params.fetch(:q, {}).permit(:price_product_price_gteq,:price_product_price_lteq, :code_cont, :material_name_cont)
  end

  def products_params
    params.require(:product).permit(:material_id, :brand_id, :measure_unit_id, :code, price_attributes: %i[product_price])
  end

  def prices_params
    params.require(:price).permit(:product_price).merge(product: @product)
  end

  def set_product
    @price = Price.find(params[:id])
  end
end
