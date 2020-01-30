# frozen_string_literal: true

Rails.application.routes.draw do
  get :build_id, to: 'application#build_id',
                 constraints: { format: :json },
                 defaults: { format: :json }
  get :health, to: 'application#health',
               constraints: { format: :json },
               defaults: { format: :json }

  constraints(CheckRequestFormat) do
    get 'welcome/index'
    root 'welcome#index'

    resources :vehicle_checkers, only: [] do
      collection do
        get :enter_details
        post :enter_details, to: 'vehicle_checkers#submit_details'
        get :confirm_details
        post :confirm_details, to: 'vehicle_checkers#submit_confirm_details'
        get :incorrect_details
        get :number_not_found
        get :exemption
        get :cannot_determine
        get :non_uk
      end
    end

    resources :air_zones, only: [] do
      collection do
        get :caz_selection
        post :submit_caz_selection
        get :compliance
      end
    end

    resources :contact_forms, only: :index do
      collection do
        post :index, to: 'contact_forms#validate'
        get :result
      end
    end

    get :service_unavailable, to: 'application#server_unavailable'
    get :cookies, to: 'cookies#index'
    get :privacy_notice, to: 'privacy_notice#index'
    get :accessibility_statement, to: 'accessibility#index'

    match '/404', to: 'errors#not_found', via: :all
    # There is no 422 error page in design systems
    match '/422', to: 'errors#internal_server_error', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
    match '/503', to: 'errors#service_unavailable', via: :all
  end
  # renders not found page for all unsupported type requests
  match '*unmatched', to: 'errors#not_found', via: :all
end
