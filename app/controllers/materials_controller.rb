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
      if @material.save
        format.html { redirect_to materials_url, notice: t('.success')}
        format.json { render :index, status: :created, location: @material }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to materials_url, notice: t('.update')}
        format.json { render :index, status: :ok, location: @material }
      else
        format.html { render :edit }
        format.json { render json: @material.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url, notice: t('.destroy')}
      format.json { head :no_content }
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
