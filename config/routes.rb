Rails.application.routes.draw do
  resources :pools
  resources :teams do 
    get "update_standings", on: :collection
  end

  resources :users

  root to: 'pools#index'
end
