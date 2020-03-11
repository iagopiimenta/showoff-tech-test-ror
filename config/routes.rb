Rails.application.routes.draw do
  resources :widgets
  resources :users do
    resources :widgets
  end

  resources :sessions do
    collection do
      delete 'sign_out'
    end
  end

  root to: "home#index"
end
