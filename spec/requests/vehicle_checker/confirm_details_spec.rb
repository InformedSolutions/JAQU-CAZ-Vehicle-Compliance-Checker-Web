# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #confirm_details', type: :request do
  subject(:http_request) { get confirm_details_vehicle_checkers_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  context 'when VRN is valid' do
    before do
      vc_details_response = file_fixture('vehicle_details_response.json').read

      stub_request(:get, /vehicle_registration/).and_return(
        body: vc_details_response
      )
    end

    it 'returns http success' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'redirects to enter_details' do
      http_request
      error = 'You must enter your registration number'
      expect(response).to redirect_to(
        enter_details_vehicle_checkers_path(error: error, vrn: vrn)
      )
    end
  end
end
