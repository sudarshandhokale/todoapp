Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :todo_lists, only: [:index, :create, :update, :destroy] do
        delete :soft_delete, on: :member
        patch :restore, on: :member
        resources :todo_items, only: :create
      end
      resources :todo_items, only: [:update, :destroy] do
        delete :soft_delete, on: :member
        patch :restore, on: :member
      end
    end
  end
  root 'home#index'
  get '*path' => 'home#index'
end
