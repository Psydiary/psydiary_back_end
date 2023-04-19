Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do

      post "/login", to: "users#login_user"
      post "/omniauth", to: "users#omniauth"
      
      resources :users, only: [:show, :create, :update] do
        get 'settings', to: 'users#edit'
        resources :microdose_log_entries, only: %i[show index create], controller: "users/microdose_log_entries"
        resources :daily_log_entries, only: %i[show create], controller: "users/daily_log_entries"
        resources :log_entries, only: [:index], controller: "users/log_entries"
        resources :protocols, only: %i[index show create]
        patch "/update_protocol", to: "users#update_protocol"
      end

      resources :protocols, only: %i[index]
    end
  end
end
