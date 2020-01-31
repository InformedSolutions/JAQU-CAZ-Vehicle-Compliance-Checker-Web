# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - POST #submit_confirm_details', type: :request do
  subject(:http_request) do
    post confirm_details_vehicle_checkers_path, params: {
      confirm_details_form:
        {
          'confirm_details' => confirmation,
          'confirm_taxi_or_phv' => confirmation,
          'undetermined' => 'false',
          'taxi_and_correct_type' => 'true'
        }
    }
  end

  let(:confirmation) { 'yes' }
  let(:confirmation_taxi_or_phv) { 'false' }

  before do
    vehicle_details = JSON.parse(file_fixture('vehicle_details_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
    add_vrn_to_session
    http_request
  end

  context 'when user confirms details and what his vehicle not a taxi or PHV' do
    it 'redirects to enter details page' do
      expect(response).to redirect_to(caz_selection_air_zones_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to incorrect details page' do
      expect(response).to redirect_to(incorrect_details_vehicle_checkers_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'renders to confirm details page' do
      expect(response).to render_template(:confirm_details)
    end
  end
end
