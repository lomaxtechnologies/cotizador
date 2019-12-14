class ClientsController < ApplicationController

  layout 'manager'
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :validate_credentials, only: [:list_deleted_clients]

  # GET /clients
  # GET /clients.json
  def index
    @search = Client.ransack(search_client_params)
    @clients = @search.result.order(name: 'asc')
    @page_size = params.fetch(:page_size, 10)
    @clients = @clients.page(params[:page]).per(@page_size)
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        notice = t('.success', name: @client.name)
        format.html { redirect_to clients_path, notice: notice}
      else
        alert = @client.errors.full_messages.join('.')
        format.html { redirect_to new_client_path, alert: alert}
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        notice = t('.update', name: @client.name)
        format.html { redirect_to clients_path, notice: notice }
      else
        alert = @client.errors.full_messages.join('.')
        format.html { redirect_to edit_client_path, alert: alert }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: t('.destroy') }
    end
  end

  # GET /api/clients
  def api_index
    search = params.fetch(:search, "").split
    query = ""
    search.each do |str|
      if query.empty?
        query += "lower(name) like '%#{str}%'"
      else
        query += "AND lower(name) like '%#{str}%'"
      end
    end

    puts query

    response_with_success(
      Client.where(query).fields_for_quotation
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :address, :nit, :phone)
  end

  def search_client_params
    params.fetch(:q,{}).permit(:name_cont)
  end
end

