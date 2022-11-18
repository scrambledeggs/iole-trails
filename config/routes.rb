Rails.application.routes.draw do
  resources :people do
    resources :practices, only: [:new, :create, :edit, :update]
  end
  resources :trails
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
