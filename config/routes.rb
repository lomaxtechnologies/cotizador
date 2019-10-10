Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

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

  namespace :users do
    resources :registrations
  end
  # Allows users to manage their own account
  get '/account', to: 'users/registrations#account', as: 'user_account'
  put '/account', to: 'users/registrations#update_account'
  # Allows admin users to reset other users's passwords
  post '/users/registrations/reset-password/:id', to: 'users/registrations#reset_password', as: 'reset_password_users_registration'

  resources :services
  get 'services/api/get-all', to: 'services#api_get_all'

  resources :measure_units

  resources :clients
  get 'clients/api/get-all', to: 'clients#api_get_all'

  resources :prices, except:[:show]
  post 'prices/upload', to: 'prices#upload', as: 'upload'
  get 'prices/dashboard', to: 'prices#dashboard', as: 'dashboard'

  resources :materials

  resources :brands, except: [:edit, :show, :new]

  get '/quotations', to: 'quotations#admin'

  root to: 'quotations#index'
end
