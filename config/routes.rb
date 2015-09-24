Rails.application.routes.draw do
  resources :teams

  resources :users

  root to: 'visitors#index'
end
