Rails.application.routes.draw do
  namespace:api do
    namespace:v1 do
      get 'journal_prompts/find', to: 'journal_prompts#find'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
