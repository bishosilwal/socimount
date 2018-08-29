Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'home/index'
  post 'page_post', to: 'home#page_post'
  get 'page_filter', to: 'home#page_filter'
  post 'save_email', to: 'home#set_email'
  get 'disconnect/:provider', to: 'home#disconnect'
  root 'home#index'
end
