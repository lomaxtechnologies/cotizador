class ApplicationController < ActionController::Base
  #before_action :authenticate_user!

  def response_with_success(data = nil)
    render status: 200, json: {
      successful: true,
      data: data
    }.to_json
  end

  def response_with_error(message = '', details = nil)
    render status: 200, json: {
      successful: false,
      error: {
        message: message,
        details: details
      }
    }.to_json
  end
end
