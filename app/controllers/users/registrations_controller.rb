class Users::RegistrationsController < ApplicationLoggedController
  layout "manager"
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @users = User.all
  end

  # GET /clients/new
  def new
    @user = User.new
  end

  # GET /clients/1/edit
  def edit
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @user = User.find(params[:id])
    end

end
