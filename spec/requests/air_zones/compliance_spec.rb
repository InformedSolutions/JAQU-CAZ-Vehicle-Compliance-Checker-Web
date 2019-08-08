# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:http_request) { post compliance_air_zones_path, params: { caz: caz } }

  let(:caz) { ['leeds'] }

  before do
    post validate_vrn_vehicle_checkers_path, params: { vrn: 'CU57ABC' }
    compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
    http_request
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end

  context 'when form is invalid' do
    let(:caz) { [] }

    it 'redirects to caz selection page' do
      expect(response).to redirect_to(caz_selection_air_zones_path)
    end
  end
end
