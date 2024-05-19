# frozen_string_literal: true
require 'sidekiq/web'
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  
  # Defines the root path route ("/")
  # root "posts#index"
  mount Sidekiq::Web => '/sidekiq'
  
  resources :applications, param: :token, only: %i[create update show] do
    resources :chats, param: :number, only: %i[create show index] do
      resources :messages, param: :number, only: %i[create show index]
    end
  end
end
