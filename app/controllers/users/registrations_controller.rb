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
      if @user.create_user(@user_detail)
        notice = "El usuario #{@user_detail.name} ha sido creado satisfactoriamente"
        format.html { redirect_to users_registrations_url , notice: notice }
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

  # PATCH/PUT /registrations/1
  def update
    respond_to do |format|
      if @user.update_user(user_params, user_detail_params)
        notice = "El usuario #{@user.user_detail.name} ha sido actualizada exitosamente"
        format.html { redirect_to users_registrations_url, notice: notice }
      else
        notice = @user.errors.full_messages.join(".") 
        notice += @user_detail.errors.full_messages.join(".") 
        format.html { redirect_to edit_users_registration_url, notice: notice}
      end
    end
  end

  # DELETE /registrations/1
  def destroy
    respond_to do |format|
      if @user.destroy_user
        notice = "El usuario #{@user.user_detail.name} ha sido eliminado exitosamente"
      else
        notice = @user.errors.full_messages.join(".") 
        notice += @user_detail.errors.full_messages.join(".") 
      end
      format.html { redirect_to users_registrations_url, notice: notice}
    end
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
