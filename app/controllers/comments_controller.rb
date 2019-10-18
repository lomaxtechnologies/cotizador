class CommentsController < ApplicationController
  layout "manager"
  before_action :set_comment, only:[:update,:destroy]
  def create
    respond_to do |format|
      comment = Comment.new(comment_params)
      comment.commentable_id = params[:commentable_id]
      comment.commentable_type = (params[:commentable_type]).humanize
      comment.user = current_user
      if user.save
        format.json {response_with_success}   
      else
        format.json {response_with_error(t('.error'),t('.no_save'))}
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.user == current_user
        format.json {response_with_success(@comment.update(update_comment_params))}  
      else
        format.json {response_with_error(t('.error'),t('.no_user'))}
      end
    end
  end

  def destroy
    if @comment.destroy
      response_with_success  
    else
      response_with_error(response_with_error(t('.error'),t('.no_delete')))
    end
  end

  def api_index
    response_with_success(Comment.all_only_identifier_fields(index_params).order(:id))
  end

  private 

  def update_comment_params
    params.require(:comment).permit(:note,:commentable_type,:commentable_id)
  end

  def index_params
    params.require(:comment).permit(:commentable_type,:commentable_id)
  end
  
  def set_comment
    @comment = Comment.find(params[:id])
  end
  def comment_params
    params.require(:comment).permit(:note)
  end

end
