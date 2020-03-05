Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'home/index'
  post 'page_post', to: 'home#page_post'
  post 'save_email', to: 'home#set_email'
  get 'disconnect/:provider', to: 'home#disconnect'
  root 'home#index'
end
