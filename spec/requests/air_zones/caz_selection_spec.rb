# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #caz_selection', type: :request do
  subject(:request) { get caz_selection_air_zones_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  before do
    caz_list_response = file_fixture('caz_list_response.json').read
    stub_request(:get, /clean_air_zones/).to_return(
      status: 200,
      body: caz_list_response,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  it 'returns http success' do
    request
    expect(response).to have_http_status(:success)
  end
end
