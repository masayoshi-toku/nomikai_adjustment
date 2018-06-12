Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users
  get "/auth/google_oauth2", as: "google_auth"
  get '/auth/:provider/callback', to: 'google_omniauths#new'
  get '/login', to: 'sessions#new'
end
