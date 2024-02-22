require 'rails_helper'

RSpec.describe 'Price', type: :request do
  describe 'GET /price' do
    it 'returns the current BTC price in USD' do
      get '/price'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['price']).to be_a(Float)
    end
  end
end