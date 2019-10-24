class AttachmentsController < ApplicationController
  layout "manager"

  before_action :set_attachment, only: [:edit, :update, :show, :destory]

  def index
    attachments = Attachment.where("quotation_id = ?", params[:quotation_id])
    response_with_success(attachments)
  end

  def new; end

  def create
    @attachment = Attachment.new(attachments_params)
    @attachment.quotation_id = params[:quotation_id]
    @attachment.user = current_user
    @attachment.location = url_for(@attachment.file)
    if @attachment.save
      response_with_success
    else
      response_with_error(t(".error"), t(".no_save"))
    end
  end

  def show
    redirect_to rails_blob_path(@attachment.file, disposition: "attachment")
  end

  def destroy
    # Just the user who created the attachment can delete

    if @attachment.user == current_user
      response_with_success(@attachment.destroy)
    else
      response_with_error(t("attachments.error"), t("attachments.no_user"))
    end
  end

  private

  def attachments_params
    params.require(:attachment).permit(:location, :file, :name)
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
