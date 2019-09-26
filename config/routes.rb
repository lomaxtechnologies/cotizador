Rails.application.routes.draw do

  resources :services
  namespace :users do
    resources :registrations
  end
  resources :measure_units
  resources :clients
  resources :prices
  resources :materials
  resources :brands

  get '/account', to: 'users/registrations#account'

  get '/quotations', to: 'quotations#admin'

  root to: 'quotations#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Overriding routes to make them point to generated controllers
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    registrations: 'users/registrations'
  }

end
