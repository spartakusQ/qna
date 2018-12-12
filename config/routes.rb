Rails.application.routes.draw do

  resources :questions, shallow: true do
    resources :answers
  end

  root to: "questions#index"
end
