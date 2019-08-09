# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #number_not_found', type: :request do
  subject { get number_not_found_vehicle_checkers_path }

  it 'returns a found response' do
    subject
    expect(response).to have_http_status(:found)
  end
end
