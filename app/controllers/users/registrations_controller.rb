class Users::RegistrationsController < ApplicationController
  layout 'manager'
  before_action :set_registration, only: %i[show edit update destroy]

  # GET /registrations
  # GET /registrations.json
  def index
    @q = User.ransack(query_params)
    @users = @q.result.order('email ASC')
    @users = @users.page(params[:page])
  end

  # GET /registrations/new
  def new
    @user = User.new
    @user_detail = UserDetail.new
  end

  # POST /registrations
  def create
    respond_to do |format|
      @user = User.create_user(create_user_params, user_detail_params)
      if @user.errors.any?
        notice = @user.errors.full_messages.join('.')
        notice += @user.user_detail.errors.full_messages.join('.')
        format.html { redirect_to new_users_registration_url, notice: notice }
      else
        notice = t('.success', username: @user.user_detail.name)
        format.html { redirect_to users_registrations_url, notice: notice }
      end
    end
  end

  # GET /registrations/1/edit
  def edit
  end

  # PATCH/PUT /registrations/1
  def update
    respond_to do |format|
      if @user.update_user(update_user_params, user_detail_params)
        notice = t('.update',username: @user.user_detail.name)
        format.html { redirect_to users_registrations_url, notice: notice }
      else
        notice = @user.errors.full_messages.join('.')
        notice += @user_detail.errors.full_messages.join('.')
        format.html { redirect_to edit_users_registration_url, notice: notice}
      end
    end
  end

  # DELETE /registrations/1
  def destroy
    respond_to do |format|
      if @user.destroy_user
        notice = t('.destroy',username: @user.user_detail.name)
      else
        notice = @user.errors.full_messages.join('.')
        notice += @user_detail.errors.full_messages.join('.')
      end
      format.html { redirect_to users_registrations_url, notice: notice }
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

  # Allows some params for the search query
  def query_params
    params.require(:q).permit(:email_cont)
  rescue ActionController::ParameterMissing
    { email_cont: '' }
  end

  # Allows some params for user creation
  def create_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  # Allows some params for user modification
  def update_user_params
    params.require(:user).permit(:password, :password_confirmation, :role)
  end

  # Allows some params for user detal modification
  def user_detail_params
    params.require(:user_detail).permit(:name, :last_name, :phone)
  end
end
