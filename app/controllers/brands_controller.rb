class BrandsController < ApplicationController
  layout 'manager'
  before_action :set_brand, only: %i[update destroy]

  # GET /brands
  # GET /brands.json
  def index
    @q = Brand.ransack(query_params)
    @brands = @q.result.order('name ASC')
    @brands = @brands.page(params[:page])
    @brand = Brand.new
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        notice = t('.success',name:@brand.name)
      else
        notice = []
        @brand.errors.each do |_attribute, error|
          notice.push(error)
        end
      end
      format.html { redirect_to brands_path, notice: notice}
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        notice = t('.update', name: @brand.name)
      else
        notice = []
        @brand.errors.full_messages.each do |error|
          notice.push(error)
        end
      end
      format.html { redirect_to brands_path, notice: notice }
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
  def query_params
    params.require(:q).permit(:name_cont)
  rescue ActionController::ParameterMissing
    { name_cont: '' }
  end

end