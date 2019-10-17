class AttachmentsController < ApplicationController
  layout "manager"
  skip_before_action :verify_authenticity_token, only: :create
  
  def index
  end
  def new
  end

  def create
    respond_to do |format|
      attachment = Attachment.new(attachments_params)
      attachment.quotation_id = params[:id]
      attachment.user = User.find(1)
      format.json{ response_with_success(attachment.save)}
    end
  end

  def destroy
    if @attachment.user == User.find(1) && @attachment.destroy
      format.json { response_with_succes}
    else
      format.json {response_with_error('error')}
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
