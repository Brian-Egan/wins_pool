Rails.application.routes.draw do
  resources :teams do 
    get "update_standings", on: :collection
  end

  resources :users

  root to: 'users#index'
end
