Rails.application.routes.draw do

  devise_for :users
  resources :questions, shallow: true do
    resources :answers, only: [:create, :edit, :update, :destroy]
  end

  root to: "questions#index"
end
