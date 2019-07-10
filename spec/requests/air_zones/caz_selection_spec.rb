# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #caz_selection', type: :request do
  subject(:request) { get caz_selection_air_zones_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  before do
    caz_list = JSON.parse(file_fixture('caz_list_response.json').read)
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
  end

  it 'returns http success' do
    request
    expect(response).to have_http_status(:success)
  end
end
