Rails.application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: 'players/omniauth_callbacks' }
  root 'static_pages#index'
  resources :games do
    member do
      put :forfeit
    end
  end
  resources :users, only: [:show, :edit, :update]
  resources :pieces, only: :update
  resources :conversations do
    resources :messages
  end
end
