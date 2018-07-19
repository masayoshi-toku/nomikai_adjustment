Rails.application.routes.draw do
  root to: 'events#index'
  resources :users, only: [:index, :show, :destroy]
  resources :events, param: 'url_path' do
    resource :reactions
  end
  get '/auth/google_oauth2', as: 'google_auth'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
end
