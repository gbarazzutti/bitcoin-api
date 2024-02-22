# app/controllers/transactions_controller.rb
class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    if @user.balance_usd >= transaction_params[:amount_sent] * @price
      @user.balance_usd -= transaction_params[:amount_sent] * @price
      @user.balance_btc += transaction_params[:amount_received]
      @user.transactions.create!(transaction_params)
      render json: @user.transactions.last, status: :created
    else
      render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
    end
    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def transaction_params
    params.require(:transaction).permit(:user_id, :coin_sent, :coin_received, :amount_sent, :amount_received)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  def price
    @price ||= HTTP.get('https://api.coindesk.com/v1/bpi/currentprice/BTC.json').parse['bpi']['USD']['rate_float']
  end
end