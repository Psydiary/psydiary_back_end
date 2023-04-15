Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :protocols, only: [:index, :show]

      post "/login", to: "users#login_user"
      
      resources :users, only: [:show, :create, :update]
    end
  end
end
