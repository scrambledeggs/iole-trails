Rails.application.routes.draw do
  root "trails#index"
  resources :people do
    resources :practices, only: %i[new create edit update]
  end
  resources :trails do
    get "eligible-people", to: "trails#eligibles", on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
