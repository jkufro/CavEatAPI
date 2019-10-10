Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'foods#index', as: :home

  resources :foods, only: [:index, :show, :update, :edit, :destroy]
  resources :ingredients, only: [:index]
  resources :nutrients, only: [:index]
  resources :users, only: [:index]
end
