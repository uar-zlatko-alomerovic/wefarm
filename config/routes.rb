Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :farmers
  get '/register', to: 'farmers#new'

  # session
  get '/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy', as: :logout
  post 'sessions/create', to: 'sessions#create'
end
