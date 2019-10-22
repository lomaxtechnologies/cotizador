class MaterialsController < ApplicationController
  layout "manager"
  before_action :set_material, only: [:show, :edit, :update, :destroy]


  # GET /materials
  # GET /materials.json
  def index
    @search = Material.ransack(search_material_params)
    @materials = @search.result.order('id ASC')
    @page_size = params.fetch(:page_size, 10)
    @materials = @materials.page(params[:page]).per(@page_size)
  end

  # GET /materials/new
  def new
    @material = Material.new
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)

    respond_to do |format|
      if @material.save
        notice = t('.success', name: @material.name)
        format.html { redirect_to materials_path, notice: notice}
      else
        alert = @material.errors.full_messages.join('.')
        format.html { redirect_to new_material_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        notice = t('.update', name: @material.name)
        format.html { redirect_to materials_path, notice: notice }
      else
        alert = @material.errors.full_messages.join('.')
        format.html { redirect_to edit_material_path, alert: alert }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url, notice: t('.destroy')}
    end
  end

  # API For materials controller

  # GET /materials/api/get-all
  def api_index
    response_with_success(Material.fields_for_quotation)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_material
    @material = Material.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def material_params
    params.require(:material).permit(:name, :description)
  end

  def search_material_params
    params.fetch(:q, {}).permit(:name_cont, :description_cont)
  end
end
