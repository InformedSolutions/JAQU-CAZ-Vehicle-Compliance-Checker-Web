# frozen_string_literal: true

require 'rails_helper'

describe ContactFormsController, type: :request do
  describe 'GET #contact_form' do
    subject(:http_request) { get contact_form_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #validate_contact_form' do
    subject(:http_request) do
      post contact_form_path, params: { 'contact_form' => params }
    end

    let(:user_email) { 'test@example.com' }
    let(:params) do
      {
        'email': user_email,
        'first_name': 'James',
        'last_name': 'Smith',
        'query_type': 'Fleets',
        'message': 'Test message'
      }
    end

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #contact_form_result' do
    subject(:http_request) { get contact_form_result_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
