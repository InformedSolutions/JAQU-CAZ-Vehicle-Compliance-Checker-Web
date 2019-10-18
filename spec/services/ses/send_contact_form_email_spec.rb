# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ses::SendContactFormEmail do
  subject(:service_call) { described_class.call(params: params) }

  let(:user_email) { 'test@example.com' }
  let(:full_name) { 'James Smith' }
  let(:query_type) { 'Fleets' }
  let(:message) { 'Test message' }

  let(:params) do
    {
      'email': user_email,
      'first_name': 'James',
      'last_name': 'Smith',
      'query_type': query_type,
      'message': message
    }.stringify_keys
  end

  context 'with valid params' do
    before do
      mailer = OpenStruct.new(deliver: true)
      allow(ContactFormMailer).to receive(:send_email).and_return(mailer)
    end

    it { is_expected.to be_truthy }

    it 'sends an email with proper params' do
      expect(ContactFormMailer).to receive(:send_email)
        .with(user_email, full_name, query_type, message)
      service_call
    end
  end

  context 'when sending emails fails' do
    before do
      allow(ContactFormMailer).to receive(:send_email).and_raise(
        Aws::SES::Errors::MessageRejected.new('', 'error')
      )
    end

    it { is_expected.to be_falsey }
  end
end
