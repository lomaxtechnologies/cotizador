class AttachmentsController < ApplicationController
  layout "manager"
  
  def index
  end
  def new
  end

  def create
    attachment = Attachment.new(attachments_params)
    attachment.quotation_id = params[:id]
    attachment.user = current_user
    if attachment.save
      response_with_success
    else
      response_with_error(t('.error'),t('.no_save'))
    end

  end

  def destroy
    # Just the user who created the attachment can delete
    if attachment.user == current_user
      response_with_success(attachment.destroy)
    else
      response_with_error(t('attachments.error'),t('attachments.no_user'))
    end
  end

  private
  def attachments_params
    params.require(:attachment).permit(:location)
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

end
