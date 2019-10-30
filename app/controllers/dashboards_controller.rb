class DashboardsController < ApplicationController
  layout "manager"

  def index;end

  def api_count_states
    count_states = Quotation.all.group(:state).count
    response_with_success(count_states)
  end
  def api_state_expired_soon
    expired_quotation = Quotation.ransack(
      state_in: [1],
      created_at_lteq: 11.days.ago, 
      created_at_gteq: 15.days.ago).result
    response_with_success(expired_quotation)
  end
  def api_info_states
    info_states = Quotation
    .joins(:user, :client)
    .joins("inner join user_details ud on ud.user_id = users.id")
    .order(state: :desc)
    .select(
      'quotations.id',
      'quotations.state',
      "concat(ud.name, ' ', ud.last_name) as name",
      'clients.name',
      "TO_CHAR(quotations.created_at, 'dd/mm/yyyy HH:MI AM') Date"

    )

    response_with_success(info_states)
  end

  def api_expired_soon
    expired_quotation = Quotation.ransack(
      state_in: [1],
      created_at_lteq: 12.days.ago, 
      created_at_gteq: 15.days.ago).result
    total_expired = expired_quotation.count
    response_with_success(total_expired)
  end

  def api_recent_comments
    last_comment = Comment.order(created_at: "desc").limit(5).map {|comment|
      comment.attributes.merge({
        user: comment.user.user_detail.name,
        date: comment.created_at
      })
    }
    response_with_success(last_comment)
  end

  def api_recent_attachments
    last_attachments = Attachment.order(created_at: "desc").limit(5).map {|attachment|
      attachment.attributes.merge({
        user: attachment.user.user_detail.name,
        quotation: attachment.quotation.id,
        client: attachment.quotation.client.name,
        date: attachment.created_at
      })
    }
    response_with_success(last_attachments)
  end

  def api_recent_quotations
    last_quotations_updated = Quotation.order(updated_at: "desc").limit(5).map {|quotation| 
      quotation.attributes.merge({
        user: quotation.user.user_detail.name,
        client: quotation.client.name,
        quotation: quotation.id,
        date: quotation.created_at
      })
    }
    response_with_success(last_quotations_updated)
  end
end
