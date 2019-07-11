# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe '#redirect_to_back' do
    subject { get confirm_details_vehicle_checkers_path, params: { vrn: 'CU57ABC' } }

    before do
      stub_request(:get, /details/).to_return(status: 400, body: nil)
    end

    it 'redirects to server unavailable page' do
      subject
      expect(response).to redirect_to(server_unavailable_path)
    end
  end

  describe 'server_unavailable' do
    subject { get server_unavailable_path }

    it 'returns 200' do
      subject
      expect(response).to be_successful
    end
  end
end
