# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #exemption', type: :request do
  subject(:request) { get exemption_vehicle_checkers_path }

  before { post validate_vrn_vehicle_checkers_path, params: { vrn: 'CU57ABC' } }

  it 'returns an ok response' do
    request
    expect(response).to have_http_status(:ok)
  end
end
