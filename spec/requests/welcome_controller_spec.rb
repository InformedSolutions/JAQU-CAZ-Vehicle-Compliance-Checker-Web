# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject { get welcome_index_path }

    context 'when API is available' do
      before do
        caz_list = JSON.parse(file_fixture('caz_list_response.json').read)
        allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
      end

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'when API is unavailable' do
      before do
        allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_raise(Errno::ECONNREFUSED)
      end

      it 'redirects to server_unavailable' do
        subject
        expect(response).to redirect_to(server_unavailable_path)
      end
    end

    context 'when API returns 500' do
      before do
        allow(ComplianceCheckerApi).to receive(:clean_air_zones)
          .and_raise(BaseApi::Error500Exception.new(500, '', {}))
      end

      it 'redirects to server_unavailable' do
        subject
        expect(response).to redirect_to(server_unavailable_path)
      end
    end
  end
end
