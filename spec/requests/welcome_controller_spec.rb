# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject { get welcome_index_path }

    context 'when API is available' do
      before do
        caz_list = JSON.parse(file_fixture('caz_list_response.json').read)
        allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
        subject
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when API is unavailable' do
      before do
        allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_raise(Errno::ECONNREFUSED)
        subject
      end

      it 'redirects to server_unavailable' do
        expect(response).to have_http_status(:service_unavailable)
      end

      it 'renders 503 error page' do
        expect(response).to render_template(:service_unavailable)
      end
    end

    context 'when API returns 500 error' do
      before do
        allow(ComplianceCheckerApi).to receive(:clean_air_zones)
          .and_raise(BaseApi::Error500Exception.new(500, '', {}))
        subject
      end

      it 'redirects to server_unavailable' do
        expect(response).to have_http_status(:service_unavailable)
      end

      it 'renders 503 error page' do
        expect(response).to render_template(:service_unavailable)
      end
    end
  end
end
