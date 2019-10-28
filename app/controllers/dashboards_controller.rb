class DashboardsController < ApplicationController
  layout "manager"

  def index;end

  def api_count_states
    count_states = Quotation.all.group(:state).count
    response_with_success(count_states)
  end
  
  def api_info_states
    count_states = Quotation.all.group(:state, :id)
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

  def api_recent_comments
    last_comment = Comment.order(created_at: "desc").limit(5).map {|attachment| 
    attachment.attributes.merge({
        user: attachment.user.user_detail.name,
        date:  attachment.created_at
      })  
    }
    response_with_success(last_comment)
  end

  def api_recent_attachments
    last_attachments = Attachment.order(created_at: "desc").limit(5).map {|attachment|
    attachment.attributes.merge({
      user: attachment.user.user_detail.name,
      quotation: attachment.quotation.id+100,
      client: attachment.quotation.client.name,
      date:  attachment.created_at
    })
    }
    response_with_success(last_attachments)
  end

  def api_recent_quotations
    last_quotations_updated = Quotation.order(updated_at: "desc").limit(5).map {|attachment| 
      attachment.attributes.merge({
        user: attachment.user.user_detail.name,
        client: attachment.client.name,
        quotation: attachment.id+100,
        date:  attachment.created_at
      })  
    }
    response_with_success(last_quotations_updated)
  end
end