Rails.application.routes.draw do

  devise_for :users
  resources :questions, shallow: true do
    resources :answers, only: [:create, :edit, :update, :destroy] do
      patch :best, on: :member
    end
  end

  root to: "questions#index"
end
