Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do

      post "/login", to: "users#login_user"
      
      resources :users, only: [:show, :create, :update] do
        resources :microdose_log_entrys, only: %i[show create], controller: "users/microdose_log_entrys"
        resources :daily_log_entries, only: %i[show], controller: "users/daily_log_entries"
      end
      
      resources :protocols, only: %i[index show create]

    end
  end
end
