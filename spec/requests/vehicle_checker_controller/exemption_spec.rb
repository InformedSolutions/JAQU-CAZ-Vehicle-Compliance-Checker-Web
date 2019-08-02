# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #exemption', type: :request do
  subject(:request) { get exemption_vehicle_checkers_path, params: { vrn: vrn } }

  let(:vrn) { 'CU57ABC' }

  it 'returns http success' do
    request
    expect(response).to have_http_status(:success)
  end
end
