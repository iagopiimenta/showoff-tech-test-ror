Rails.application.routes.draw do
  resources :widgets
  resources :users do
    resources :widgets

    collection do
      post :sign_in
      delete :sign_out
    end
  end

  root to: "home#index"
end
