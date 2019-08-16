# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehicleCheckersController - GET #number_not_found', type: :request do
  subject { get number_not_found_vehicle_checkers_path }

  context 'with VRN in session' do
    before { add_vrn_to_session }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end
  end
end
