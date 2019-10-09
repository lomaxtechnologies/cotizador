class QuotationsController < ApplicationController
  layout "manager"
  
  def index
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new
  end

end
