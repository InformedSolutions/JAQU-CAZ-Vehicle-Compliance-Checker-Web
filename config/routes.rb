# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :vehicle_checkers do
    collection do
      get :enter_details
      get :confirm_details
      get :incorrect_details
      get :user_confirm_details
      get :number_not_found
    end
  end
end
