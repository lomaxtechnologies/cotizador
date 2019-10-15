class QuotationsController < ApplicationController
  layout "manager"
  skip_before_action :verify_authenticity_token, only: :api_add_comment
  
  def index
  end

  def admin
  end

  def new
  end

  def create
    respond_to do |format|
      @quotation = Quotation.new(quotation_params.merge(user: User.find(1)))
      @quotation.save
      if @quotation.errors.any?
        errors = @quotation.errors.full_messages
        puts errors
        format.html { redirect_to new_users_registration_url, alert: errors }
        format.json { response_with_error(t('.error'), errors) }
      else
        format.html { redirect_to users_registrations_url, notice: t('.success') }
        format.json { response_with_success }
      end
    end
  end

  def api_get_list
    responseWithSuccess(Comment.list)
  end

  def api_get_comment
    responseWithSuccess(Comment.get_comment(params[:id]))
  end

  def api_add_comment
    commentable = Quotation.find(params[:id])
    comment = commentable.
    respond_to do |format|
      if true
        format.json {render :json => {:result => 'success'}}
      else
        format.json {render :json => {:result => 'fail'}}
      end
    end
    #p comment
  end
  private

  def quotation_params
    params.require(:quotation).permit(
      :quotation_date,
      :credits,
      :payment_conditions,
      :warranty,
      :client_id,
      quotation_products_attributes: %i[amount percent product_id],
      quotation_services_attributes: %i[amount percent service_id]
    )
  end
end
