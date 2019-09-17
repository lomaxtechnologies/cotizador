Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Overriding routes to make them point to generated controllers
  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords',
      unlocks: 'users/unlocks'
    }
  end

end
