class PricesController < ApplicationController
layout "manager"
  # GET /prices
  # GET /prices.json
  def index
    @prices = Price.all
  end

  def import
    #MaterialsParser.new({path: params[:file]}).charge_data
    notice = t('.import')
    redirect_to prices_path, notice: notice
  end
  
  def upload
    path = 'storage/listado.xlsx'
    MaterialsParser.new({path: path}).load_data
  end

end