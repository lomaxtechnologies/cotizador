# frozen_string_literal: true

class PricesController < ApplicationController
  layout 'manager'

  # GET /prices
  # GET /prices.json
  def index;end

  def new;end

  def create;end

  def destroy;end

  def dashboard
    @prices = Price.ransack(created_at_gteq: 5.minutes.ago).result
  end

  private

  def prices_params
    params.require(:price).permit(:product_price).merge(product: @product)
  end

end
