require 'rails_helper'

describe 'SalesController', type: :request do
  describe 'POST /sales/import' do
    let(:file) { fixture_file_upload('sales_records_valid.csv') }

    before do
      post '/sales/import', params: {file: file}
    end

    context 'when provided file is a CSV file' do
      it 'returns job ID' do
        expect(response.status).to eq 200
        json_response = JSON.parse(response.body)
        expect(json_response).to include("job_id")
        expect(json_response["job_id"]).to be_present
      end

      it 'does not save sales records synchronously' do
        get '/sales'
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(0)
      end

      context 'when job has been processed' do
        context 'and all data in the file is valid' do
          it 'persists all sales to database' do
            expect(response.status).to eq 200
            Sidekiq::Worker.drain_all

            get '/sales'
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).size).to eq(2)
          end

          context 'when uploading next file, which has missing fields' do
            it 'does not persist data to database' do
              file_path = fixture_file_upload('sales_records_invalid_missing_region.csv')
              post '/sales/import', params: {file: file_path}
              expect(response.status).to eq 200
              Sidekiq::Worker.drain_all rescue nil

              get '/sales'
              expect(response.status).to eq 200
              expect(JSON.parse(response.body).size).to eq(2)
            end
          end
        end

        context 'and file contains missing region' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_region.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing country' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_country.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing item type' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_item_type.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing order date' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_order_date.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing order id' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_order_id.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing sales channel' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_sales_channel.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing total revenue' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_total_revenue.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing unit price' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_unit_price.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains missing units sold' do
          let(:file) { fixture_file_upload('sales_records_invalid_missing_units_sold.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains negative units sold' do
          let(:file) { fixture_file_upload('sales_records_invalid_negative_units_sold.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains negative unit price' do
          let(:file) { fixture_file_upload('sales_records_invalid_negative_unit_price.csv') }
          include_examples 'does not persist data to database'
        end

        context 'and file contains negative total revenue' do
          let(:file) { fixture_file_upload('sales_records_invalid_negative_total_revenue.csv') }
          include_examples 'does not persist data to database'
        end
      end
    end

    context 'when provided file is not a CSV file' do
      let(:file) { fixture_file_upload('image.jpg') }

      it 'returns 422 code' do
        expect(response.status).to eq 422
      end
    end

    context 'when no file is provided' do
      let(:file) { nil }

      it 'returns 422 code with error message' do
        expect(response.status).to eq 422
      end
    end
  end
  
  describe 'GET /sales' do
    context 'when sales have been imported to the system' do
      before do
        post '/sales/import', params: {file: fixture_file_upload('sales_records_valid.csv')}
        expect(response.status).to eq 200
        Sidekiq::Worker.drain_all rescue nil
      end

      it 'should return all sales records ordered by ID' do
        get '/sales'

        json_response = JSON.parse(response.body)
        expected = [
          {
            id: 1,
            channel: "Offline",
            country: "Tuvalu",
            item_type: "Baby Food",
            order_date: "2014-05-01",
            order_id: "669165933",
            region: "Australia and Oceania",
            total_revenue_in_cents: 2246464,
            unit_price_in_cents: 25528,
            units: 88
          },
          {
            id: 2,
            channel: "Online",
            country: "Grenada",
            item_type: "Cereal",
            order_date: "2014-05-02",
            order_id: "963881480",
            region: "Central America and the Caribbean",
            total_revenue_in_cents: 205700,
            unit_price_in_cents: 20570,
            units: 10
          }
        ]

        expect(json_response).to eq(expected.map(&:stringify_keys))
      end
    end
  end
end