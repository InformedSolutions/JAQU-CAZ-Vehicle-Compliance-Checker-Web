# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleCheckersController, type: :request do
  describe 'GET #enter_details' do
    subject { get enter_details_vehicle_checkers_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #confirm_details' do
    subject { get confirm_details_vehicle_checkers_path, params: { vrn: 'CU57ABC' } }

    before do
      vc_details_response = file_fixture('vehicle_details_response.json').read

      stub_request(:get, /vehicle_registration/).and_return(
        body: vc_details_response
      )
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #incorrect_details' do
    subject { get incorrect_details_vehicle_checkers_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
