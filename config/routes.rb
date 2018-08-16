Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'home/index'
  post 'page_post', to: 'home#page_post'
  get 'page_filter', to: 'home#page_filter'
  root 'home#index'
end
