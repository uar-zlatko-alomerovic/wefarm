Rails.application.routes.draw do
  resources :farmers
  root to: 'welcome#index'
end
