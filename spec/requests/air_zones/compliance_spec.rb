# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - GET #compliance', type: :request do
  subject(:request) { get compliance_air_zones_path, params: { caz: ['London'] } }

  it 'returns http success' do
    request
    expect(response).to have_http_status(:success)
  end
end
