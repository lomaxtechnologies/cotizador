class QuotationsController < ApplicationController
  layout "manager"
  before_action :set_quotation, only: [:api_update, :destroy, :api_show]
  
  def index
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
  end

  def create
    respond_to do |format|
      @quotation = Quotation.new(quotation_params.merge(user: current_user))
      @quotation.save
      if @quotation.errors.any?
        errors = @quotation.errors.full_messages
        format.html { redirect_to new_users_registration_url, alert: errors }
        format.json { response_with_error(t('quotations.error'), errors) }
      else
        format.html { redirect_to users_registrations_url, notice: t('.success') }
        format.json { response_with_success }
      end
    end
  end

  def destroy
    if @quotation.destroy
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
    end
  end
  def api_types
    response_with_success(Quotation.quotation_types)
  end

  def api_type_by_quotation
    response_with_success(Quotation.type(params))
  end

  def api_create_header
    @quotation = Quotation.new(quotation_params.merge(user: current_user))
    @quotation.save
    if @quotation.errors.any?
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
    else
      data = {id: @quotation.id}
      response_with_success(data)
    end
  end

  def api_index
    response_with_success(Quotation.all_only_identifier_fields.order(:id))
  end

  def api_update
    if @quotation.update(quotation_params.merge(user: current_user))
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
    end
  end

  def api_show
    response_with_success(@quotation)
  end
  private

  def quotation_params
    params.require(:quotation).permit(
      :quotation_date,
      :quotation_type,
      :credits,
      :payment_condition,
      :warranty,
      :client_id,
      quotation_products_attributes: %i[amount percent product_id],
      quotation_services_attributes: %i[amount percent service_id]
    ).merge({
      user: current_user,
      state: Quotation.states[:created]
    })
  end

  def set_quotation
    @quotation = Quotation.find(params[:id])
  end

end
