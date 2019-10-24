class QuotationsController < ApplicationController
  layout "manager"
  before_action :set_quotation, only: %i[update destroy show api_type api_activate api_conditions api_header]

  # POST /quotations
  def create
    @quotation = Quotation.new(quotation_params.merge(
      user: current_user, 
      state: Quotation.states[:created]
    ))
    @quotation.save
    if @quotation.errors.any?
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    else
      data = { id: @quotation.id }
      response_with_success(data)
    end
  end

  # GET /quotations/:id
  def show
    response_with_success(@quotation.detailed_info)
  end

  # PUT /quotations/:id
  def update
    if @quotation.update(quotation_params.merge(user: current_user))
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    end
  end

  # DELETE /quotations/:id
  def destroy
    if @quotation.destroy
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    end
  end

  # GET api/quotations 
  def api_index
    response_with_success(Quotation.header_fields.order(:id))
  end

  # GET /api/quotations/types
  def api_types
    quotation_types = []
    Quotation.quotation_types.each do |key, _value|
      quotation_types.push(value: key, text: t( ".#{key}" ))
    end
    response_with_success(quotation_types)
  end

  # GET /api/quotations/:id/type
  def api_type
    response_with_success(Quotation.type(params))
  end

  # GET /api/quotations/:id/conditions
  def api_conditions
    response_with_success(@quotation.conditions_only)
  end

  def api_header
    response_with_success(@quotation.header_only)
  end

  # PUT /api/quotations/:id/activate
  def api_activate
    if @quotation.activate
      response_with_success
    else 
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    end
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
      quotation_services_attributes: %i[id amount percent service_id]
    )
  end

  def set_quotation
    @quotation = Quotation.find(params[:id])
  end
end
