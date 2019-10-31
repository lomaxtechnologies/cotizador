class QuotationsController < ApplicationController
  layout "manager"
  before_action :set_quotation, only: %i[
    update
    destroy
    show
    api_type
    api_activate
    api_approve
    api_expire
    api_state
    api_conditions
    api_header
    api_services
    api_products
    api_clone
    api_duplicate
    generate_excel
  ]

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
      response_with_success({
        quotation_services: @quotation.services_ids,
        quotation_products: @quotation.products_ids
      })
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
    response_with_success(Quotation.header_fields.order(id: "desc"))
  end

  # GET /api/quotations/types
  def api_types
    quotation_types = []
    Quotation.quotation_types.each do |key, _value|
      quotation_types.push(value: key, text: t( ".#{key}" ))
    end
    response_with_success(quotation_types)
  end

  # GET /api/quotations/states
  def api_states
    quotation_states = []
    Quotation.states.each do |key, _value|
      quotation_states.push(value: key, text: t( ".#{key}" ))
    end
    response_with_success(quotation_states)
  end

  # GET /api/quotations/:id/type
  def api_type
    response_with_success(Quotation.type(params))
  end

  # GET /api/quotations/:id/state
  def api_state
    response_with_success(@quotation.state)
  end

  # GET /api/quotations/:id/conditions
  def api_conditions
    response_with_success(@quotation.conditions_only)
  end

  # GET /api/quotations/:id/header
  def api_header
    response_with_success(@quotation.header_only)
  end

  # GET /api/quotations/:id/services
  def api_services
    response_with_success(@quotation.services_only)
  end

  # GET /api/quotations/:id/products
  def api_products
    response_with_success(@quotation.products_only)
  end

  # POST /api/quotations/:id/clone
  def api_clone
    duplicate_quotation(Quotation.states[:active], t('.error'))
  end

  # POST /api/quotations/:id/duplicate
  def api_duplicate
    duplicate_quotation(Quotation.states[:created], t('.error'))
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

  # PUT /api/quotations/:id/approve
  def api_approve
    if @quotation.approve
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    end
  end

  # PUT /api/quotations/:id/expire
  def api_expire
    if @quotation.expire
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error( t('.error'), errors )
    end
  end


  def generate_excel
    workbook = CreateExcelQuotation.new(id: params[:id]).create
    client = @quotation.client.name
    filename = "#{Date.today.strftime("%Y%m%d")}-#{@quotation.id.to_s}-#{client}.xlsx"
    return send_data workbook, filename: filename, type: 'application/excel', disposition: 'inline'
  end

  def generate_pdf
    @quotation = Quotation.find(params[:id]).detailed_info
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        'quotations/pdf_view.pdf.haml', 
        layout: 'pdf_layout.html.haml'),
      header: {
        content: render_to_string(
          'quotations/pdf_header.pdf.haml',
          layout: 'pdf_layout.html.haml'
        )
      },
      footer: {
        content: render_to_string(
          'quotations/pdf_footer.pdf.haml',
          layout: 'pdf_layout.html.haml'
        )
      }
    )
    client = @quotation[:client].name
    filename = "#{Date.today.strftime("%Y%m%d")}-#{@quotation['id'].to_s}-#{client}.pdf"
    send_data pdf, filename: filename
  end

  private

  # Duplicates a quotation and changes the user and state
  def duplicate_quotation(state, error_message)
    new_quotation = @quotation.clone_and_update
    if @quotation.errors.any?
      errors = @quotation.errors.full_messages
      response_with_error( error_message, errors )
    else
      new_quotation.user = current_user
      new_quotation.state = state
      new_quotation.save
      if new_quotation.errors.any?
        errors = new_quotation.errors.full_messages
        response_with_error( error_message, errors )
      else
        response_with_success({quotation_id: new_quotation.id})
      end
    end
  end

  def quotation_params
    params.require(:quotation).permit(
      :quotation_date,
      :quotation_type,
      :payment_condition,
      :warranty,
      :client_id,
      quotation_products_attributes: %i[id amount percent product_id _destroy],
      quotation_services_attributes: %i[id amount percent service_id _destroy]
    )
  end

  def set_quotation
    @quotation = Quotation.find(params[:id])
  end
end
