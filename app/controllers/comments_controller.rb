class CommentsController < ApplicationController

  def create
  end

  def update
  end

  private 

  def comments_params
    params.require(:comment).permit(:note,:comment_type,:parent_type,:parent_id)
  end

end
