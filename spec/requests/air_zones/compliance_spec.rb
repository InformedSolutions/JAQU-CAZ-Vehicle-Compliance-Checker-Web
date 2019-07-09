# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:http_request) { get compliance_air_zones_path, params: { vrn: vrn, caz: caz } }

  let(:vrn) { 'CU57ABC' }
  let(:caz) { ['leeds'] }

  before do
    compliance_response = file_fixture('compliance_response.json').read
    stub_request(:get, /compliance/).to_return(
      status: 200,
      body: compliance_response,
      headers: { 'Content-Type' => 'application/json' }
    )

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
