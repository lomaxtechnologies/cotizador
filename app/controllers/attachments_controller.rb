class AttachmentsController < ApplicationController
  layout "manager"
  def index
  end
  def new
  end

  def create
    respond_to do |format|
      attachment = Attachment.new(attachments_params)
      attachment.quotation_id = params[:id]
      attachment.user = current_user
      format.json{ response_with_success(attachment.save)}
    end
  end

  def destroy
    attachment = Attachment.find(attachment_destroy_params[:id])
    respond_to do |format|
      if attachment.user == current_user
        format.json { response_with_success(attachment.destroy)}
      else
        format.json {response_with_error(t('attachments.error'),t('attachments.no_user'))}
      end
    end
  end

  private
  def attachments_params
    params.require(:attachment).permit(:location)
  end

  def attachment_destroy_params
    params.require(:attachment).permit(:id)
  end

end
