class QuotationsController < ApplicationController
  layout "manager"
  skip_before_action :verify_authenticity_token, only: :api_add_comment
  
  def index
  end

  def admin
  end

  def new
    @quotation = Quotation.new
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
    def comment_params
      params.require(:comments).permit(:note, user_id: current_user.id)
    end
end
