require 'rails_helper'

shared_examples 'does not persist data to database' do
  it 'does not persist any data to database' do
    expect(response.status).to eq 200
    Sidekiq::Worker.drain_all rescue nil

    get '/sales'
    expect(response.status).to eq 200
    expect(JSON.parse(response.body).size).to eq(0)
  end
end
