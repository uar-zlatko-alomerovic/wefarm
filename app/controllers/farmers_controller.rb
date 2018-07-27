class FarmersController < ApplicationController
  before_action :set_farmer, only: [:show, :edit, :update, :destroy]

  def show
    @is_admin = current_user && current_user.id == @farmer.id
  end

  def index
    @farmers = Farmer.all
  end

  def new
    if current_user
      redirect_to root_path, notice: 'You are already registered!'
    else
      @farmer = Farmer.new
    end
  end

  def create
    @farmer = Farmer.new(farmer_params)

    respond_to do |format|
      if @farmer.save
        format.html { redirect_to @farmer, notice: 'Farmer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    redirect_to @farmer if current_user.id != @farmer.id
  end

  def update
    respond_to do |format|
      if @farmer.update(farmer_params)
        format.html { redirect_to @farmer, notice: 'Farmer was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @farmer.destroy
    respond_to do |format|
      format.html { redirect_to farmers_url, notice: 'Farmer was successfully destroyed.' }
    end
  end

  # GET /farmers/oauth/1
  def oauth
    @farmer = Farmer.find(params[:farmer_id])
    return redirect_to('/') unless params[:code]
    begin
      @farmer.request_wepay_access_token(params[:code], redirect_uri('oauth'))
    rescue StandardError => e
      error = e.message
    end

    return redirect_to @farmer, alert: error if error
    redirect_to @farmer, notice: 'We successfully connected you to WePay!'
  end

  # GET /farmers/buy/1
  def buy
    @farmer = Farmer.find(params[:farmer_id])
    begin
      @checkout = @farmer.create_checkout(redirect_uri('payment_success'))
    rescue StandardError => e
      redirect_to @farmer, alert: e.message
    end
  end

  # GET /farmers/payment_success/1
  def payment_success
    @farmer = Farmer.find(params[:farmer_id])
    return redirect_to @farmer, alert: 'Error - Checkout ID is expected' unless params[:checkout_id]
    return redirect_to @farmer, alert: "Error - #{params['error_description']}" if params['error'] && params['error_description']
    redirect_to @farmer, notice: 'Thanks for the payment! You should receive a confirmation email shortly.'
  end

  private

  def redirect_uri(action)
    url_for(controller: 'farmers', action: action, farmer_id: params[:farmer_id], host: request.host_with_port)
  end

  def set_farmer
    @farmer = Farmer.find(params[:id])
  end

  def farmer_params
    params.require(:farmer).permit(
      :name, :email, :password, :farm, :produce, :produce_price, :wepay_access_token, :wepay_account_id, :farmer_id
    )
  end
end
