Rails.application.routes.draw do
  resources :widgets
  resources :sessions

  root to: "home#index"
end
