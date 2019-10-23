class CommentsController < ApplicationController
  layout "manager"
  before_action :set_comment, only:[:update,:destroy]

  # GET /comments
  def index 
  end

  # GET /comments/1
  def show; end

  # GET /comments/new
  def new; end

  # GET /comments/1/edit
  def edit; end
  
  def create
    comment = Comment.new(comment_params)
    comment.user = current_user
    if comment.save
      response_with_success
    else
      response_with_error(t('.error'), comment.errors.full_messages)
    end
  end

  def update
    #Only the user who created the comment can modify it.
    if @comment.user == current_user
      response_with_success(@comment.update(update_comment_params))
    else
      response_with_error(t('.error'),t('.no_user'))
    end
  end

  def destroy
    response_with_success(@comment.destroy)  
  end

  def api_list
    comments = Comment
      .joins(:user)
      .joins("inner join user_details ud on ud.user_id = users.id")
      .where(commentable_type: params[:commentable_type])
      .where(commentable_id: params[:commentable_id])
      .order(id: :desc)
      .select(
        'comments.id',
        "concat(ud.name, ' ', ud.last_name) as name",
        'comments.note',
        "TO_CHAR(comments.created_at, 'dd/mm/yyyy HH:MI AM') Date"
      )
    response_with_success(comments)
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
    params.require(:comment).permit(:note, :commentable_type, :commentable_id)
  end

end
