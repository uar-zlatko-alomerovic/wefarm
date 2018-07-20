Rails.application.routes.draw do
  root to: 'welcome#index'

  # session
  get '/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy', as: :logout
  post 'sessions/create', to: 'sessions#create'

  resources :farmers
end
