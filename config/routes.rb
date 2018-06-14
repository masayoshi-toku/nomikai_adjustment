Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users, only: [:index, :show, :destroy]
  resources :events, only: [:show, :new, :edit, :create, :update, :destroy]
  get "/auth/google_oauth2", as: "google_auth"
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
end
