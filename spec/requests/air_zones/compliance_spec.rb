# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:http_request) { get compliance_air_zones_path }

  let(:caz) { ['a49afb83-d1b3-48b6-b08b-5db8142045dc'] }

  before do
    add_vrn_to_session(vrn: 'CU57ABC', checked_zones: caz)
  end

  context 'when api returns 200 status' do
    before do
      compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
      allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
      http_request
    end

    it 'returns an ok response' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the compliance view' do
      expect(response).to render_template(:compliance)
    end
  end

  context 'when api returns 422 status' do
    before do
      allow(ComplianceCheckerApi).to receive(:vehicle_compliance)
        .and_raise(BaseApi::Error422Exception.new(422, '',
                                                  'message' => 'Something went wrong'))
      http_request
    end

    it 'redirects to unable to determine compliance page' do
      expect(response).to redirect_to(cannot_determine_vehicle_checkers_path)
    end
  end
end
