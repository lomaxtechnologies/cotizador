Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_scope :user do
    get "reset-password-email" => "users/passwords#new", as: "new_user_password"
    get "reset-password" => "users/passwords#edit", as: "edit_user_password"
  end

  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       passwords: "users/passwords",
                       unlocks: "users/unlocks",
                       registrations: "users/registrations",
                     }

  namespace :users do
    resources :registrations
  end
  # Allows users to manage their own account
  get "/account", to: "users/registrations#account", as: "user_account"
  put "/account", to: "users/registrations#update_account"
  # Allows admin users to reset other users's passwords
  post "/users/registrations/reset-password/:id", to: "users/registrations#reset_password", as: "reset_password_users_registration"

  resources :services
  resources :measure_units
  resources :clients

  resources :products, except: [:show]
  post "products/upload", to: "products#upload", as: "upload"
  get "products/download", to: "products#download_price", as: "download"
  get "products/dashboard", to: "prices#dashboard", as: "dashboard"

  resources :materials

  resources :brands, except: [:edit, :show, :new]

  resources :quotations
  post "/quotations/:id/excel", to: "quotations#generate_excel"

  resources :dashboards

  resources :comments

  root to: 'dashboards#index'

  scope :api do
    get "/clients", to: "clients#api_index"
    get "/comparative", to: "products#api_comparative"
    get "/simple", to: "products#api_simple"
    get "/products_by_material", to: "products#products_by_material"
    get "/products_by_brand", to: "products#products_by_brand"
    scope :quotations do
      get "/", to: "quotations#api_index"
      get "/types", to: "quotations#api_types"
      get "/:id/type", to: "quotations#api_type"
      get "/:id/conditions", to: "quotations#api_conditions"
      get "/:id/header", to: "quotations#api_header"
      get "/:id/services", to: "quotations#api_services"
      get "/:id/products", to: "quotations#api_products"
      put "/:id/activate", to: "quotations#api_activate"
      put "/:id/update", to: "quotations#update"

      # Attachments routes with basic actions
      get "/:quotation_id/attachments", to: "attachments#index"
      get "/:quotation_id/attachments/:id", to: "attachments#show"
      post "/:quotation_id/attachments/create", to: "attachments#create"
      delete "/:quotation_id/attachments/:id/destroy", to: "attachments#destroy"
    end
    scope :services do
      put "/batch", to: "services#api_update_batch"
      get "/", to: "services#api_index"
    end
    scope :comments do
      get '/:commentable_type/:commentable_id', to: 'comments#api_list'
    end
  end
end
