Rails.application.routes.draw do
  root "trails#index"
  resources :people do
    resources :practices, only: %i[new create update]
    resources :runs, only: %i[show new create update]
  end
  resources :trails do
    get "eligible-people", to: "trails#eligibles", on: :member
    resources :races do
      put "finish", to: "races#finish", on: :member
    end
  end

  get "races", to: "races#all"
end
