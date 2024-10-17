class SalesController < ApplicationController
  def index
    render json: Sale.order(:id)
  end

  def import
    file = params[:file]

    if file.blank?
      render json: {}, status: :unprocessable_entity
      return
    end

    content_type = file.content_type
    unless content_type == "text/csv"
      render json: {}, status: :unprocessable_entity
      return
    end

    csv_content = file.read
    job_id = SalesImportJob.perform_async(csv_content)
    render json: { job_id: job_id }, status: :ok
  end
end
