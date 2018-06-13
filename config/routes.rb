Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users, only: [:index, :show, :destroy]
  get "/auth/google_oauth2", as: "google_auth"
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
end
