class ClientsController < ApplicationLoggedController
  layout "manager"
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  

  # GET /clients
  # GET /clients.json
  def index
    @q = Client.ransack(search_client_params)
    @clients = @q.result
    @clients = @clients.page(params[:page])
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
        format.html { redirect_to clients_url, notice: 'Client was successfully created.' }
        format.json { render :index, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
        format.json { render :index, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_delete_client
   @clients = Client.only_deleted
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
      begin
        return params.require(:q).permit(:name_cont)
      rescue ActionController::ParameterMissing
        return {email_cont: ""}
      end
    end
end
