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
    expired_quotation = expired_quotation.count
    response_with_success(expired_quotation)
  end
end