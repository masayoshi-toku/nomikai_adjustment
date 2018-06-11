Rails.application.routes.draw do
  resources :users
  get "/auth/google_oauth2", as: "google_auth"
  get '/auth/:provider/callback', to: 'users#create'
  get '/login', to: 'sessions#new'
end
