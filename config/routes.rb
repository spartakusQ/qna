Rails.application.routes.draw do
  
  resources :questions do
    resources :answer
  end

end
