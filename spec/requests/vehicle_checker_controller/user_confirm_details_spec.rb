# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #user_confirm_details', type: :request do
  subject(:http_request) do
    get user_confirm_details_vehicle_checkers_path, params: {
      'confirm-vehicle' => confirmation,
      vrn: vrn
    }
  end

  let(:confirmation) { 'yes' }
  let(:vrn) { 'CU57ABC' }

  context 'when user confirms details' do
    it 'redirects to enter_details' do
      http_request
      expect(response).to redirect_to(caz_selection_air_zones_path(vrn: vrn))
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to incorrect_details' do
      http_request
      expect(response).to redirect_to(incorrect_details_vehicle_checkers_path(vrn: vrn))
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'redirects to confirm_details page' do
      http_request
      expect(response).to redirect_to(confirm_details_vehicle_checkers_path(vrn: vrn))
    end
  end
end
