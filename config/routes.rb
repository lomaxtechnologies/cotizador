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

  resources :prices, except:[:show]
  post 'prices/upload', to: 'prices#upload', as: 'upload'
  get 'prices/dashboard', to: 'prices#dashboard', as: 'dashboard'

  resources :materials

  resources :brands, except: [:edit, :show, :new]
  
  root to: 'quotations#index'

  resources :quotations
  scope :api do
    get '/clients', to: 'clients#api_index'
    get '/materials', to: 'materials#api_index'
    get '/products_by_material', to: 'prices#products_by_material'
    get '/quotations', to: 'quotations#api_index'
    scope :quotations do
      get '/types', to: 'quotations#api_types'
      get '/:id', to: 'quotations#api_show'
      post '/header', to: 'quotations#api_create_header'
      post '/:id/attachments/create', to: 'attachments#create'
      delete '/:id/attachments/destroy', to: 'attachments#destroy'
      get '/type_by_quotation', to: 'quotations#api_type_by_quotation'
      put '/header/:id', to: 'quotations#api_update_header'
      post '/id/service', to: 'quotations#api_create_service'
    end
    scope :comments do
      get '/', to: 'comments#api_index'
      post '/(:commentable_type)/:commentable_id', to: 'comments#create', defaults: {commentable_type: 'Quotation'}
      patch '/update/:id', to: 'comments#update'
      delete '/delete/:id', to: 'comments#destroy'
    end
  end
end
