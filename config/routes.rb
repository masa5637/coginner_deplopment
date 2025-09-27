Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :works, only: [:index, :show, :new, :create]
  devise_for :users

  resources :profiles, only: [:show, :edit, :update]
  # Defines the root path route ("/")
  # root "posts#index"
end
