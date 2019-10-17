class QuotationsController < ApplicationController
  layout "manager"
  def index
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
  end

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

  def api_types
    response_with_success(Quotation.quotation_types)
  end

  def api_type_by_quotation
    response_with_success(Quotation.type)
  end

  def api_create_header
    @quotation = Quotation.new(quotation_params.merge(user: current_user))
    puts @quotation
    @quotation.save
    if @quotation.errors.any?
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
    else
      data = {code: @quotation.code}
      response_with_success(data)
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(
      :quotation_date,
      :quotation_type,
      :credits,
      :payment_conditions,
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
