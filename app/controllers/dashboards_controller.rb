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
      created_at_lteq: 12.days.ago,
      created_at_gteq: 15.days.ago
    ).result.includes(:client, user: :user_detail)

    expired_quotation = expired_quotation.map do |quotation| {
      id: quotation.id,
      user: quotation.user.user_detail.name,
      name: quotation.client.name,
      date: quotation.quotation_date
    }
    end

    response_with_success(expired_quotation)
  end
  def api_info_states
    info_states = {}
    info_states['active'] = []
    info_states['created'] = []
    info_states['accepted'] = []
    info_states['expired'] = []
    quotations = Quotation
                 .joins(:user, :client)
                 .joins("inner join user_details ud
                   on ud.user_id = users.id")
                 .order(state: :desc)
                 .select(
                   'quotations.id',
                   'quotations.state',
                   "concat(ud.name) as name_user",
                   'clients.name',
                   "TO_CHAR(quotations.quotation_date, 'dd/mm/yyyy') Date"
                 )

    quotations.each do |state|
      if state.active?
        info_states['active'].push(state)
      elsif state.created?
        info_states['created'].push(state)
      elsif state.accepted?
        info_states['accepted'].push(state)
      else
        info_states['expired'].push(state)
      end
    end

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
