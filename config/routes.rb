Rails.application.routes.draw do
  resources :user_sessions, only: [:create]

  get '/login', to: 'user_sessions#new'
  get '/logout', to: 'user_sessions#destroy'

  root to: 'home#index'
end
