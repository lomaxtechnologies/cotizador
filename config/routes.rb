Rails.application.routes.draw do

  resources :services
  namespace :users do
    resources :registrations
  end
  resources :measure_units
  resources :clients
  resources :prices
  resources :materials
  resources :brands, except: [:edit, :show, :new]

  get '/account', to: 'users/registrations#account'

  get '/quotations', to: 'quotations#admin'

  root to: 'quotations#index'

  devise_scope :user do
    get 'reset-password-email' => 'users/passwords#new', as: 'new_user_password'
    get 'reset-password' => 'users/passwords#edit', as: 'edit_user_password'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    registrations: 'users/registrations'
  }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

end
