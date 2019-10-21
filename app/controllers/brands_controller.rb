class BrandsController < ApplicationController
  layout 'manager'
  before_action :set_brand, only: %i[update destroy]

  # GET /brands
  # GET /brands.json
  def index
    @search = Brand.ransack(search_service_params)
    @brands = @search.result.order('name ASC')
    @page_size = params.fetch(:page_size,10)
    @brands = @brands.page(params[:page]).per(@page_size)
    @brand = Brand.new
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        notice = t('.success', name: @brand.name)
        format.html { redirect_to brands_path, notice: notice}
      else
        alert = @brand.errors.full_messages.join('.')
        format.html { redirect_to brands_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        notice = t('.update', name: @brand.name)
        format.html { redirect_to brands_path, notice: notice }
      else
        alert = @brand.errors.full_messages.join('.')
        format.html { redirect_to brands_path, alert: alert }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand.destroy
    respond_to do |format|
      notice = t('.destroy', name: @brand.name)
      format.html { redirect_to brands_url, notice: notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brand
    @brand = Brand.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def brand_params
    params.require(:brand).permit(:name)
  end

  # Allows some params for the search query
  def search_service_params
    params.fetch(:q, {}).permit(:name_cont)
  end

end
