# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:http_request) { get compliance_air_zones_path, params: { vrn: vrn, caz: caz } }

  let(:vrn) { 'CU57ABC' }
  let(:caz) { ['leeds'] }

  before do
    compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
    http_request
  end

  it 'returns http success' do
    expect(response).to have_http_status(:success)
  end

  context 'when form is invalid' do
    let(:caz) { [] }

    it 'redirects to caz selection page' do
      expect(response).to redirect_to(caz_selection_air_zones_path(vrn: vrn))
    end
  end
end
