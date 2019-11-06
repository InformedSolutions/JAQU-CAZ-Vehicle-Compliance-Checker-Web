# frozen_string_literal: true

require 'rails_helper'

describe SendSqsMessage do
  subject(:service) { described_class.call(contact_form: form) }

  let(:message_id) { SecureRandom.uuid }
  let(:form) { ContactForm.new(params) }
  let(:first_name) { 'James' }
  let(:last_name) { 'Smith' }
  let(:email) { 'test@example.com' }
  let(:query_type) { 'Fleets' }
  let(:message) { 'Test message' }

  let(:params) do
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      email_confirmation: email,
      query_type: query_type,
      message: message
    }
  end

  context 'when the call to SQS is successful' do
    before do
      allow(AWS_SQS).to receive(:send_message).and_return(OpenStruct.new(message_id: message_id))
    end

    it 'returns the message id' do
      expect(service).to eq(message_id)
    end
  end

  context 'when the call to SQS is unsuccessful' do
    before do
      allow(AWS_SQS).to receive(:send_message).and_raise(
        Aws::SQS::Errors::InvalidMessageContents.new('', '')
      )
    end

    it 'returns false' do
      expect(service).to be_falsey
    end
  end
end
