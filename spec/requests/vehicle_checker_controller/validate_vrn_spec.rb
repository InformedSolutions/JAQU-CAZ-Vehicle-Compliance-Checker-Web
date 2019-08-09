# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #validate_vrn', type: :request do
  subject(:http_request) { post validate_vrn_vehicle_checkers_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }
  let(:vehicle_details) { JSON.parse(file_fixture('vehicle_details_response.json').read) }

  before { http_request }

  context 'when VRN is valid' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
    end

    it 'returns a found response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'when VRN is not valid' do
    let(:vrn) { '' }

    it 'redirects to enter details page' do
      expect(response).to redirect_to(enter_details_vehicle_checkers_path)
    end
  end
end
