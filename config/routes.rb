Rails.application.routes.draw do
  root 'messages#index'

  resources :questions do
    member do
      post :edit
      post :new
    end
  end
  resources :messages do
    member do
      post :edit
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
