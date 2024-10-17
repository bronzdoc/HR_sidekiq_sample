class SalesImportJob
  include Sidekiq::Job

  def perform(csv_content)
    Sale.import_csv(csv_content)
  end
end
