Rails.application.routes.draw do

  devise_for :users

  concern :votable do
    member do
      post :rating_up, :rating_down
      delete :revote
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :answers, concerns: :votable, only: [:create, :edit, :update, :destroy] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  root to: "questions#index"
end
