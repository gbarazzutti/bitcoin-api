# app/controllers/price_controller.rb
class PriceController < ApplicationController
    def show
        response = HTTP.get('https://api.coindesk.com/v1/bpi/currentprice/BTC.json')
        price = response.parse['bpi']['USD']['rate_float']
        render json: { price: price }
    end
end