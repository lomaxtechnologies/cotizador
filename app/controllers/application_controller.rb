class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def responseWithSuccess(data=nil)
    render status: 200, json:{
      succesful: true,
      data: data
    }.to_json
  end

  def responseWithError(message="",details=nil)
    render status: 200, json:{
      succesful: false,
      error:{
        message: message,
        destails: details
      }
    }.to_json
  end
end
