class DashboardsController < ApplicationController
  layout "manager"

  def index;end

  def api_count_states
    count_states = Quotation.all.group(:state).count
    response_with_success(count_states)
  end

  def api_expired_soon
    expired_quotation = Quotation.ransack(
      state_in: [0, 1],
      created_at_lteq: 11.days.ago, 
      created_at_gteq: 15.days.ago).result
    total_expired = expired_quotation.count
    response_with_success(total_expired)
  end

  def api_recents_comment
    last_comment = Comment.ransack(created_at_gteq: 3.days.ago).result.map {|attachment| 
    comment.attributes.merge({
        user: comment.user.user_detail.name
      })  
    }
    response_with_success(last_comment)
  end

  def api_recents_attachment
    last_attachment = Attachment.ransack(created_at_gteq: 3.days.ago).result.map {|attachment| 
      attachment.attributes.merge({
        user: attachment.user.user_detail.name
      })  
    }
    response_with_success(last_attachment)
  end
end