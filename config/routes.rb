# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :vehicle_checkers, only: [] do
    collection do
      get :enter_details
      post :validate_vrn
      get :validate_vrn, to: redirect('vehicle_checkers/enter_details')
      get :confirm_details
      get :incorrect_details
      get :user_confirm_details
      get :number_not_found
      get :exemption
      get :non_uk
    end
  end

  resources :air_zones, only: [] do
    collection do
      get :caz_selection
      post :compliance
      get :compliance, to: redirect('air_zones/caz_selection')
    end
  end

  get :server_unavailable, to: 'application#server_unavailable'
  get :health, to: 'application#health'
  get :build_id, to: 'application#build_id'
  get :cookies, to: 'cookies#index'
end
