Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :farmers
  get '/register', to: 'farmers#new'

  # WePay routes
  get '/farmers/oauth(/:farmer_id)', to: 'farmers#oauth'
  get '/farmers/buy(/:farmer_id)', to: 'farmers#buy'
  get '/farmers/payment_success(/:farmer_id)', to: 'farmers#payment_success'

  # session
  get '/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy', as: :logout
  post 'sessions/create', to: 'sessions#create'
end
