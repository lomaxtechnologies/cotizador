class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  layout "manager"
  # GET /services
  # GET /services.json
  def index
    @q = Service.ransack(search_service_params)
    @services = @q.result.order('name ASC')
    @services = @services.page(params[:page])
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        notice = t('.success', name: @service.name)
        format.html { redirect_to services_path, notice: notice}
      else
        alert = @service.errors.full_messages.join('.')
        format.html { redirect_to services_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        notice = t('.update', name: @service.name)
        format.html { redirect_to services_path, alert: notice }
      else
        alert = @service.errors.full_messages.join('.')
        format.html { redirect_to services_path, alert: alert }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, alert: t('.destroy') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :description, :creation_price, :actual_price, :creator_user, :modifier_user, :status)
  end

  def search_service_params
    params.fetch(:q, {}).permit(:name_cont)
  end
end
