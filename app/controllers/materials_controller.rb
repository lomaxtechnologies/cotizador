class MaterialsController < ApplicationController
  layout "manager"
  before_action :set_material, only: [:show, :edit, :update, :destroy]


  # GET /materials
  # GET /materials.json
  def index
    @q = Material.ransack(search_material_params)
    @materials = @q.result
    @materials = @materials.page(params[:page])
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
      if @client.save
        notice = t('.success', name: @client.name)
        format.html { redirect_to clients_path, notice: notice}
      else
        alert = @client.errors.full_messages.join('.')
        format.html { redirect_to clients_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        notice = t('.update', name: @client.name)
        format.html { redirect_to clients_path, alert: notice }
      else
        alert = @client.errors.full_messages.join('.')
        format.html { redirect_to clients_path, alert: alert }
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

  def  list_deleted_materials
   @materials = Material.only_deleted
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params.require(:material).permit(:code, :name, :description)
    end

    def search_material_params
      begin
        return params.require(:q).permit(:name_cont)
      rescue ActionController::ParameterMissing
        return {email_cont: ""}
      end
    end
end
