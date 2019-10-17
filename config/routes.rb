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
  patch 'services/api/update-batch', to: 'services#api_update_batch'

  resources :measure_units

  resources :clients

  resources :prices, except:[:show]
  post 'prices/upload', to: 'prices#upload', as: 'upload'
  get 'prices/dashboard', to: 'prices#dashboard', as: 'dashboard'
  get 'prices/api/get-products', to: 'prices#api_get_by_material'

  resources :materials
  get 'materials/api/get-all', to: 'materials#api_get_all'

  resources :brands, except: [:edit, :show, :new]

  get 'quotations/api/api-get-list', to: 'quotations#api_get_list'
  get 'quotations/api/api-get-comment', to: 'quotations#api_get_comment'
  post 'quotations/api/api-add-comment', to: 'quotations#api_add_comment'
  patch 'quotations/api/api-update-comment', to: 'quotations#api_update_comment'
  delete 'quotations/api/api-delete-comment', to: 'quotations#api_delete_comment'
  post 'quotations/:id/attachments/create', to: 'quotations#create_attachment'
  delete 'quotations/:id/attachments/delete', to: 'quotations#delete_attachment'
  get 'quotations', to: 'quotations#index'
  root to: 'quotations#index'

  resources :quotations
  scope :api do
    get '/clients', to: 'clients#api_index'
    scope :quotations do
      get '/types', to: 'quotations#api_types'
      post '/header', to: 'quotations#api_create_header'
    end
  end
end
