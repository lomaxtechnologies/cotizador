class Users::RegistrationsController < ApplicationLoggedController
  layout "manager"
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  # GET /registrations
  # GET /registrations.json
  def index
    @users = User.all
  end

  # GET /registrations/new
  def new
    @user = User.new
  end

  # GET /registrations/1/edit
  def edit
  end
  # GET /account
  def account
    @user = current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @user = User.find(params[:id])
    end

end
