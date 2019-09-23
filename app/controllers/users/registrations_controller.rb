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
    @user_detail = UserDetail.new
  end

  # POST /registrations
  def create
    @user = User.new(user_params)
    @user_detail = UserDetail.new(user_detail_params)
    respond_to do |format|
      if @user.save_user(@user_detail)
        format.html { redirect_to users_registrations_url , notice: "El usuario #{@user_detail.name} ha sido creado satisfactoriamente" }
      else
        notice = @user.errors.full_messages.join(".") 
        notice += @user_detail.errors.full_messages.join(".") 
        format.html { redirect_to new_users_registration_url, notice: notice}
      end
    end
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

    def user_params
      return params.require(:user).permit(:email,:password,:password_confirmation,:role_id)
    end

    def user_detail_params
      return params.require(:user_detail).permit(:name,:last_name,:phone)
    end

end
