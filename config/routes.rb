Rails.application.routes.draw do
  root "trails#index"
  resources :people 
  resources :practices, only: [:new, :create, :edit, :update]
  resources :trails
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
