class PricesController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy]
layout "manager"
  # GET /prices
  # GET /prices.json
  def index
    @prices = Price.all
  end
  def import
    Price.import(params[:file])
    redirect_to root_url, notice: "Prices imported."
  end
end