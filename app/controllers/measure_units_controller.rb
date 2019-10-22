class MeasureUnitsController < ApplicationController
  layout "manager"
  before_action :set_measure_unit, only: [:show, :edit, :update, :destroy]
  

  # GET /measure_units
  # GET /measure_units.json
  def index
    @search = MeasureUnit.ransack(search_measure_unit_params)
    @measure_units = @search.result
    @page_size = params.fetch(:page_size,10)
    @measure_units = @measure_units.page(params[:page]).per(@page_size)
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
        notice = t('.success', name: @measure_unit.name)
        format.html { redirect_to measure_units_path, notice: notice}
      else
        alert = @measure_unit.errors.full_messages.join('.')
        format.html { redirect_to measure_units_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /measure_units/1
  # PATCH/PUT /measure_units/1.json
  def update
    respond_to do |format|
      if @measure_unit.update(measure_unit_params)
        notice = t('.update', name: @measure_unit.name)
        format.html { redirect_to measure_units_path, notice: notice }
      else
        alert = @measure_unit.errors.full_messages.join('.')
        format.html { redirect_to measure_units_path, alert: alert }
      end
    end
  end

  # DELETE /measure_units/1
  # DELETE /measure_units/1.json
  def destroy
    @measure_unit.destroy
    respond_to do |format|
      format.html { redirect_to measure_units_url, notice: t('.destroy') }
    end
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