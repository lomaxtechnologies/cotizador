class ApplicationController < ActionController::Base
  #before_action :authenticate_user!

  def add_api_status(data,error=nil)
    result = { data: data, error: error }
    if error
      result[:status] = :error
    else
      result[:status] = :success
    end
    result
  end
end
