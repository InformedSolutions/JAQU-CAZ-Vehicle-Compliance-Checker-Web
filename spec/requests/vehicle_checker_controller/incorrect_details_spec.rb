# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #incorrect_details', type: :request do
  subject(:request) { get incorrect_details_vehicle_checkers_path }

  it 'returns http success' do
    request
    expect(response).to have_http_status(:success)
  end
end
