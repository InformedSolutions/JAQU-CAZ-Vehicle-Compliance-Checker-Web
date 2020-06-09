# frozen_string_literal: true

require 'rails_helper'

describe PrivacyNoticeController, type: :request do
  describe 'GET #index' do
    subject { get privacy_notice_path }

    it 'returns a success response' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
