class MeasureUnitsController < ApplicationController
layout "manager"
  before_action :set_measure_unit, only: [:show, :edit, :update, :destroy]
  

  # GET /measure_units
  # GET /measure_units.json
  def index
    @q = MeasureUnit.ransack(search_measure_unit_params)
    @measure_units = @q.result
    @measure_units = @measure_units.page(params[:page])
  end

  # GET /measure_units/new
  def new
    @measure_unit = MeasureUnit.new
  end

  # POST /measure_units
  # POST /measure_units.json
  def create
    @measure_unit = MeasureUnit.new(measure_unit_params)

    respond_to do |format|
      if @measure_unit.save
        format.html { redirect_to measure_units_url, notice: t('.success') }
        format.json { render :index, status: :created, location: @measure_unit }
      else
        format.html { render :new }
        format.json { render json: @measure_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measure_units/1
  # PATCH/PUT /measure_units/1.json
  def update
    respond_to do |format|
      if @measure_unit.update(measure_unit_params)
        format.html { redirect_to measure_units_url, notice: t('.update') }
        format.json { render :index, status: :ok, location: @measure_unit }
      else
        format.html { render :edit }
        format.json { render json: @measure_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measure_units/1
  # DELETE /measure_units/1.json
  def destroy
    @measure_unit.destroy
    respond_to do |format|
      format.html { redirect_to measure_units_url, notice: t('.destroy') }
      format.json { head :no_content }
    end
  end

  def  list_deleted_measure_units
   @measure_units = MeasureUnit.only_deleted
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measure_unit
      @measure_unit = MeasureUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measure_unit_params
      params.require(:measure_unit).permit(:name, :unit_type)
    end

    def search_measure_unit_params
      params.fetch(:q,{}).permit(:name_cont)
    end
end