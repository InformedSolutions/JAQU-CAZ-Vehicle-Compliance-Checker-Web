# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController do
  describe 'GET #accessibility_statement' do
    subject { get accessibility_statement_path }

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #cookies' do
    subject { get cookies_path }

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #privacy_notice' do
    subject { get privacy_notice_path }

    before do
      caz_details = read_response('caz_list_response.json')['cleanAirZones']
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_details)
    end

    it 'assigns only displayable cazes' do
      subject
      expect(assigns[:caz_link_display_data].count).to eq(2)
    end

    it 'returns a 200 OK status' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
