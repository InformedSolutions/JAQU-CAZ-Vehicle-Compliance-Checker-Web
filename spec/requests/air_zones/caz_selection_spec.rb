# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #caz_selection', type: :request do
  subject(:request) { get caz_selection_air_zones_path }

  before do
    caz_list = JSON.parse(file_fixture('caz_list_response.json').read)
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
    post validate_vrn_vehicle_checkers_path, params: { vrn: 'CU57ABC' }
  end

  it 'returns a success response' do
    request
    expect(response).to have_http_status(:success)
  end
end
