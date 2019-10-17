# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactFormMailer, type: :mailer do
  let(:user_email) { 'test@example.com' }
  let(:full_name) { 'James Smith' }
  let(:query_type) { 'Fleets' }
  let(:message) { 'Test message' }

  describe '.send_email' do
    subject(:mail) { described_class.send_email(user_email, full_name, query_type, message) }

    it { expect(mail.to).to include(Rails.configuration.x.contact_form_email) }

    it 'renders user email address' do
      expect(mail.body.encoded).to have_content(user_email)
    end

    it 'renders message' do
      expect(mail.body.encoded).to have_content(message)
    end

    it 'renders full_name' do
      expect(mail.body.encoded).to have_content(full_name)
    end
  end
end
