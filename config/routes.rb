Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'home/index'
  post 'page_post', to: 'home#page_post'
  root 'home#index'
end
