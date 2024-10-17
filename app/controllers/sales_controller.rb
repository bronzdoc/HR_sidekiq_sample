class SalesController < ApplicationController
  def index
    render json: Sale.order(:id)
  end
end