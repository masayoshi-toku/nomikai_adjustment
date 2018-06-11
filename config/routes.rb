Rails.application.routes.draw do
  resources :users
  get '/auth/:provider/callback', to: 'users#create'
  get "/auth/google_oauth2", as: "google_auth"
end
