Rails.application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: 'players/omniauth_callbacks' }
  root 'static_pages#index'
  resources :games do
    put '/castle' => 'special_moves#castle'
  end
  resources :pieces, only: :update
end
