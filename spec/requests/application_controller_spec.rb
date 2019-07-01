# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe '#redirect_to_back' do
    subject { get confirm_details_vehicle_checkers_path, params: { vrn: 'CU12345' } }

    before do
      stub_request(:get, /vehicle_registration/).to_return(status: 400, body: nil)
    end

    it 'redirects to root path' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
