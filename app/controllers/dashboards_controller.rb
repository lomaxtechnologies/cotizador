class DashboardsController < ApplicationController
    layout "manager"

    def index;end

    def api_count_states
        count_states = Quotation.all.group(:state).count
        response_with_success(count_states)
    end
end
