# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :vehicle_checkers, only: [] do
    collection do
      get :enter_details
      get :confirm_details
      get :incorrect_details
      get :user_confirm_details
      get :number_not_found
      get :exemption
    end
  end

  resources :air_zones, only: [] do
    collection do
      get :caz_selection
      get :compliance
    end
  end

  get 'server_unavailable', to: 'application#server_unavailable'
  get 'health', to: 'application#health'
  get 'cookies', to: 'cookies#index'
end
