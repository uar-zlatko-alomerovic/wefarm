class Farmer < ActiveRecord::Base
  validates :password, presence: true
  validates :password, length: { in: 6..200 }
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: /@/, message: ' is invalid' }

  def password
    password_hash ? @password ||= BCrypt::Password.new(password_hash) : nil
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, test_password)
    farmer = Farmer.find_by(email: email)
    farmer && farmer.password == test_password ? farmer : nil
  end

  # returns a url
  def wepay_authorization_url(redirect_uri)
    Wefarm::Application::WEPAY.oauth2_authorize_url(redirect_uri, email, name)
  end

  # takes a code returned by wepay oauth2 authorization
  # and makes an api call to generate oauth2 token for this farmer.
  def request_wepay_access_token(code, redirect_uri)
    response = Wefarm::Application::WEPAY.oauth2_token(code, redirect_uri)
    return raise 'Error - ' + response['error_description'] if response['error']
    return raise 'Error requesting access from WePay' unless response['access_token']
    self.wepay_access_token = response['access_token']
    save
  end

  def wepay_access_token?
    !no_access_token?
  end

  # makes an api call to WePay to check if current access token for farmer is still valid
  def valid_wepay_access_token?
    return false if no_access_token?
    response = Wefarm::Application::WEPAY.call('/user', wepay_access_token)
    response && response['user_id'] ? true : false
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this farmer.
  def request_wepay_access_token(code, redirect_uri)
    response = Wefarm::Application::WEPAY.oauth2_token(code, redirect_uri)
    return raise 'Error - ' + response['error_description'] if response['error']
    return raise 'Error requesting access from WePay' unless response['access_token']
    self.wepay_access_token = response['access_token']

    save

    create_wepay_account
  end

  def wepay_account?
    wepay_account_id != 0 && !wepay_account_id.nil?
  end

  # creates a WePay account for this farmer with the farm's name
  def create_wepay_account
    return raise 'Error - cannot create WePay account' unless wepay_access_token? && !wepay_account?
    params = { name: farm, description: 'Farm selling ' + produce }
    response = Wefarm::Application::WEPAY.call('/account/create', wepay_access_token, params)

    return raise 'Error - ' + response['error_description'] unless response['account_id']
    self.wepay_account_id = response['account_id']
    save
  end

  private

  def no_access_token?
    wepay_access_token.blank?
  end
end
