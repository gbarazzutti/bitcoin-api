require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  describe 'POST /transactions' do
    it 'creates a new transaction' do
      user = create(:user)
      price = 50_000.00
      post '/transactions', params: {
        user_id: user.id,
        transaction: {
          coin_sent: 'USD',
          coin_received: 'BTC',
          amount_sent: 100.00,
          amount_received: 0.0002
        }
      }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['amount_sent']).to eq(100.00)
      expect(JSON.parse(response.body)['amount_received']).to eq(0.0002)
      expect(user.balance_usd).to eq(0.00)
      expect(user.balance_btc).to eq(0.0002)
    end
  end

  describe 'GET /transactions/:id' do
    it 'returns the details of a transaction' do
      transaction = create(:transaction)
      get "/transactions/#{transaction.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(transaction.id)
      expect(JSON.parse(response.body)['user_id']).to eq(transaction.user_id)
      expect(JSON.parse(response.body)['coin_sent']).to eq(transaction.coin_sent)
      expect(JSON.parse(response.body)['coin_received']).to eq(transaction.coin_received)
      expect(JSON.parse(response.body)['amount_sent']).to eq(transaction.amount_sent)
      expect(JSON.parse(response.body)['amount_received']).to eq(transaction.amount_received)
    end
  end
end