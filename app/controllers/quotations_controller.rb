class QuotationsController < ApplicationController
  layout "manager"
  before_action :set_quotation, only: [:api_update_header, :destroy]
  
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

  def destroy
    if @quotation.destroy
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
    end
  end

  def create_attachment
    respond_to do |format|
      @quotation = Attachment.new(attachment_params)
      @quotation.save
      if @quotation.errors.any?
        errors = @quotation.errors.full_messages
        format.html { redirect_to quotations_url, alert: errors }
        format.json { response_with_error(t('quotations.error'), errors) }
      else
        format.html { redirect_to quotations_url, notice: t('.success') }
        format.json { response_with_success }
      end
    end
  end

  def delete_attachment
    respond_to do |format|
      if Attachment.exists?(id: attachment_params[:id])
        user_id = Attachment.find(api_update_params[:id]).user_id
        if user_id == api_delete_params[:user][:id]
          Attachment.find(api_update_params[:id]).destroy
          format.html { redirect_to quotations_url, notice: t('.success') }
          format.json { response_with_success }
        else
          format.html { redirect_to quotations_url, alert:t('quotations.no_user')}
          format.json { response_with_error(t('quotations.error'), t('quotations.no_user'))}
        end
      end
      format.json { response_with_error(t('quotations.error'), t('quotations.no_exist'))}
    end
  end

  def api_types
    response_with_success(Quotation.quotation_types)
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

  def api_update_header
    if @quotation.update(quotation_params.merge(user: current_user))
      response_with_success
    else
      errors = @quotation.errors.full_messages
      response_with_error(t('quotations.error'), errors)
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

  def comments_params
    params.require(:comment).permit(:note).merge(user: current_user)
  end

  def set_quotation
    @quotation = Quotation.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:location).merge(user: current_user,quotation_id: params[:id])
  end

  def attachment_delete_params
    params.require(:attachment).permit(:id).merge(user: current_user,quotation_id: params[:id])
  end

  def api_update_params
    params.require(:comment).permit(:id,:note).merge(user: current_user)
  end

  def api_delete_params
    params.require(:comment).permit(:id).merge(user: current_user)
  end

end
