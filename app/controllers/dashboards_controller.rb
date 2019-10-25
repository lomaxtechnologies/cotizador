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
    last_comment = Comment.order(created_at: "desc").limit(5).map {|attachment| 
    attachment.attributes.merge({
        user: attachment.user.user_detail.name
      })  
    }
    response_with_success(last_comment)
  end

  def api_recents_attachment
    last_attachment = Attachment.order(created_at: "desc").limit(5).map {|attachment| 
      attachment.attributes.merge({
        user: attachment.user.user_detail.name,
        quotation: attachment.quotation.id
      })  
    }
    response_with_success(last_attachment)
  end

  def api_recents_quotation
    last_update_quotation = Quotation.order(created_at: "desc").limit(5).map {|attachment| 
      attachment.attributes.merge({
        user: attachment.user.user_detail.name
      })  
    }
    response_with_success(last_update_quotation)
  end
end