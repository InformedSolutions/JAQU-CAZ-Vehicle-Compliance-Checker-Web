# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #confirm_details', type: :request do
  subject(:http_request) { get confirm_details_vehicle_checkers_path }

  let(:vrn) { 'CU57ABC' }
  let(:vehicle_details) { JSON.parse(file_fixture('vehicle_details_response.json').read) }

  before do
    post validate_vrn_vehicle_checkers_path, params: { vrn: vrn }
  end

  context 'when VRN is valid' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
      http_request
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    context 'when vehicle is exempt' do
      let(:vehicle_details) { { 'isExempt' => true } }

      it 'redirects to exemption page' do
        expect(response).to redirect_to(exemption_vehicle_checkers_path)
      end
    end
  end

  context 'when API is unavailable' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details).and_raise(Errno::ECONNREFUSED)
      http_request
    end

    it 'redirects to server unavailable' do
      expect(response).to redirect_to(server_unavailable_path)
    end
  end

  context 'when vehicle is not found' do
    let(:vrn) { 'CU57ABD' }

    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_details)
        .and_raise(BaseApi::Error404Exception.new(404, '',
                                                  'registrationNumber' => vrn))
      http_request
    end

    it 'redirects to number not found page' do
      expect(response).to redirect_to(number_not_found_vehicle_checkers_path)
    end
  end
end
