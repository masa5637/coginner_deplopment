Rails.application.routes.draw do
  get 'home/index'
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :works, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :edit, :update]
  end

  # ✅ 単数形に変更（resource）にする
  resource :profile, only: [:show, :edit, :update]
  resources :users, only: [:show] do
    member do
      get :followings
      get :followers
    end
  end

  # ✅ いいね一覧
  resources :likes, only: [:index]

  resources :relationships, only: [:create, :destroy]

  resources :rooms, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:create, :destroy]
  end
end
