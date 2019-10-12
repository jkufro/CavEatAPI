Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'foods#index', as: :home

  mount SwaggerUiEngine::Engine, at: "/api-docs"
  resources :apidocs, only: [:index]

  resources :foods, only: [:index, :show, :update, :edit, :destroy]
  resources :ingredients, only: [:index, :show, :update, :edit, :destroy]
  resources :nutrients, only: [:index, :show, :update, :edit, :destroy]
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  namespace :api do
    namespace :v1 do
      post :upc, to: 'foods#show_by_upc'
      post :strings, to: 'foods#show_by_strings'
    end
  end
end
