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

  # ✅ いいね一覧
  resources :likes, only: [:index]
end
