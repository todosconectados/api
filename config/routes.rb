# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: %i[create] do
    post :activate, on: :member, to: 'users#activate'
    post :validate, on: :member, to: 'users#validate'
  end

  resources :leads, only: %i[create]
end
