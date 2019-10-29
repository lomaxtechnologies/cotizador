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
    filename = Date.today.strftime("%Y%m%d")+"-"+@quotation.id.to_s+"-"+client+".xlsx"
    return send_data workbook, filename: filename, type: 'application/excel', disposition: 'inline'
  end

  def generate_PDF
    @quotation = Quotation.find(params[:id])
    p "CONTROLADOR"
    p @quotation
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "prueba",
        template:'quotations/pdf_view.pdf.haml', 
        layout: 'pdf_layout.html.haml'
      end
    end
    #pdf_html = ActionController::Base.new.render_to_string(template: 'quotations/pdf_view.pdf.haml', layout: 'pdf_layout.html.haml')
    #pdf = WickedPdf.new.pdf_from_string(pdf_html)
    #send_data pdf, filename: 'prueba.pdf'
  end

  private

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
