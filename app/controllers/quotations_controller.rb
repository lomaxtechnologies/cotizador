class QuotationsController < ApplicationController
  layout "manager"
  skip_before_action :verify_authenticity_token, only: [:api_add_comment, :api_update_comment, :api_delete_comment]
  
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
        format.json { response_with_error(t('quotations.error'), errors) }
      else
        format.html { redirect_to users_registrations_url, notice: t('.success') }
        format.json { response_with_success }
      end
    end
  end

  def api_get_list
    response_with_success(Comment.list)
  end

  def api_get_comment
    response_with_success(Comment.get_comment(set_quotation.id))
  end

  def api_add_comment
    comment = Quotation.find(set_quotation.id).comments.create(comments_params)
    respond_to do |format|
      if comment.errors.any?
        format.json {response_with_error(t('quotations.error'), errors)}
      else
        format.json {response_with_success}
      end
    end
  end

  def api_update_comment
    respond_to do |format|
      if Comment.exists?(id: api_update_params[:id])
        Comment.find(api_update_params[:id]).update(api_update_params)
        format.json {response_with_success}
      else
        format.json {response_with_error(t('quotations.error'),t('quotations.no_exist'))}
      end
    end
  end

  def api_delete_comment
    respond_to do |format|
      if Comment.exists?(id: api_delete_params[:id])
        user_id = Comment.find(api_update_params[:id]).user_id
        if user_id == api_delete_params[:user][:id]
          Comment.find(api_update_params[:id]).destroy
          format.json {response_with_success}
        else
          format.json {response_with_error(t('quotations.error'),t('quotations.no_user'))}
        end
      end
      format.json {response_with_error(t('quotations.error'),t('quotations.no_exist'))}
    end
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

  def comments_params
    params.require(:comment).permit(:note).merge(user: User.find(1))
  end

  def set_quotation
    @price = Quotation.find(params[:id])
  end

  def api_update_params
    params.require(:comment).permit(:id,:note).merge(user: User.find(1))
  end

  def api_delete_params
    params.require(:comment).permit(:id).merge(user: User.find(1))
  end
end
