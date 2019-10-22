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
  get 'api/services/', to: 'services#api_index'
  patch 'services/api/update-batch', to: 'services#api_update_batch'

  resources :measure_units

  resources :clients

  resources :products, except:[:show]
  post 'products/upload', to: 'products#upload', as: 'upload'
  get 'products/dashboard', to: 'prices#dashboard', as: 'dashboard'

  resources :materials

  resources :brands, except: [:edit, :show, :new]

  resources :quotations

  
  root to: 'quotations#index'

  scope :api do
    get '/clients', to: 'clients#api_index'
    get '/comparative', to: 'products#api_comparative'
    get '/simple', to: 'products#api_simple'
    get '/only_brand', to: 'products#api_only_brand'
    get '/products_by_material', to: 'products#products_by_material'
    get '/quotations', to: 'quotations#api_index'
    get '/products_by_brand', to: 'products#products_by_brand'
    scope :quotations do
      get '/types', to: 'quotations#api_types'
      get '/:id/type', to: 'quotations#api_type'
      post '/:id/attachments/create', to: 'attachments#create'
      put '/:id/update', to: 'quotations#update'
      delete '/:id/attachments/destroy', to: 'attachments#destroy'
    end

    scope :comments do
      get '/', to: 'comments#api_index'
      post '/(:commentable_type)/:commentable_id', to: 'comments#create', defaults: {commentable_type: 'Quotation'}
      patch '/update/:id', to: 'comments#update'
      delete '/delete/:id', to: 'comments#destroy'
    end
  end
end
