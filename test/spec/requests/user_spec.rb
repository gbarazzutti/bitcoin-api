require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/:id/transactions' do
    it 'returns a list of transactions for a user' do
      user = create(:user)
      create_list(:transaction, 3, user: user)
      get "/users/#{user.id}/transactions"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end