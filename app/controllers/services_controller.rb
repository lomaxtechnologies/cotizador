class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  layout "manager"
  # GET /services
  # GET /services.json
  def index
    @q = Service.ransack(search_service_params)
    @services = @q.result.order('name ASC')
    @page_size = params.fetch(:page_size, 10)
    @services = @services.page(params[:page]).per(@page_size)
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
        format.html { redirect_to new_service_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        notice = t('.update', name: @service.name)
        format.html { redirect_to services_path, notice: notice }
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
      format.html { redirect_to services_url, notice: t('.destroy') }
    end
  end

  # API For Services Controller
  # GET /services/api/get-all
  def api_get_all
    response_with_success(Service.all_only_indentifier_fields)
  end

  # PATCH /services/api/update-batch
  def api_update_batch
    errors = []
    api_services_params.each do |service_params|
      service = Service.find_by_id(service_params[:id])
      if service
        service.update_column(:price, service_params[:price])
      else
        errors.push(t('.errors.service_does_not_exist', service: service_params[:id]))
      end
    end
    errors.empty? ? response_with_success : response_with_error(t('.errors.main'), errors)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  def api_services_params
    allowed_params = []
    params.fetch(:services, []).each do |params|
      allowed_params.push(params.permit(:id, :price))
    end
    allowed_params
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :description, :price)
  end

  def search_service_params
    params.fetch(:q, {}).permit(:name_cont)
  end
end
