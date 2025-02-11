Rails.application.routes.draw do
  root "trails#index"
  resources :people do
    resources :practices, only: %i[new create update]
    resources :runs, only: %i[show new create update]
  end
  resources :trails do
    get "eligible-people", to: "trails#eligibles", on: :member
    resources :races
  end

  get "races", to: "races#all"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
