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
        format.json { render :show, status: :created, location: @farmer }
      else
        format.html { render :new }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
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
        format.json { render :show, status: :ok, location: @farmer }
      else
        format.html { render :edit }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @farmer.destroy
    respond_to do |format|
      format.html { redirect_to farmers_url, notice: 'Farmer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /farmers/oauth/1
  def oauth
    @farmer = Farmer.find(params[:farmer_id])
    return redirect_to('/') unless params[:code]
    redirect_uri = url_for(controller: 'farmers', action: 'oauth', farmer_id: params[:farmer_id], host: request.host_with_port)
    begin
      @farmer.request_wepay_access_token(params[:code], redirect_uri)
    rescue StandardError => e
      error = e.message
    end

    if error
      redirect_to @farmer, alert: error
    else
      redirect_to @farmer, notice: 'We successfully connected you to WePay!'
    end
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:id])
  end

  def farmer_params
    params.require(:farmer).permit(
      :name, :email, :password, :farm, :produce, :produce_price, :wepay_access_token, :wepay_account_id, :farmer_id
    )
  end
end
