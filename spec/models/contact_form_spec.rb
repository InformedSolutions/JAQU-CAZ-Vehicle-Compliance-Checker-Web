# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:first_name) { 'James' }
  let(:last_name) { 'Smith' }
  let(:email) { 'test@example.com' }
  let(:email_confirmation) { 'test@example.com' }
  let(:query_type) { 'Fleets' }
  let(:message) { 'Test message' }

  let(:params) do
    {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'email_confirmation': email_confirmation,
      'query_type': query_type,
      'message': message
    }
  end

  context 'with proper params' do
    before { form.valid? }

    it { is_expected.to be_valid }

    it 'has an empty hash as error_object' do
      expect(form.errors.messages).to eq({})
    end
  end

  context 'with invalid params' do
    before { form.valid? }

    context 'when first_name is empty' do
      let(:first_name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:first_name])
          .to include('First name is required')
      end
    end

    context 'when last_name is empty' do
      let(:last_name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:last_name])
          .to include('Last name is required')
      end
    end

    context 'when email is empty' do
      let(:email) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email])
          .to include('Email is required', 'Email and email address confirmation must be the same')
      end
    end

    context 'when invalid email format' do
      let(:email) { 'user.example.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email])
          .to include('The Email is in an invalid format')
      end
    end

    context 'when email_confirmation is empty' do
      let(:email_confirmation) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email_confirmation])
          .to include(
            'Email confirmation is required',
            'Email and email address confirmation must be the same'
          )
      end
    end

    context 'when email and email_confirmation is not same' do
      let(:email_confirmation) { 'another_email@example.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper email error message' do
        expect(form.errors.messages[:email])
          .to include(
            'Email and email address confirmation must be the same'
          )
      end

      it 'has a proper email_confirmation error message' do
        expect(form.errors.messages[:email_confirmation])
          .to include(
            'Email and email address confirmation must be the same'
          )
      end
    end

    context 'when query_type is empty' do
      let(:query_type) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:query_type])
          .to include(
            'Query type is required'
          )
      end
    end

    context 'when message is empty' do
      let(:message) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:message])
          .to include(
            'Message is required'
          )
      end
    end

    context 'when message is too long' do
      let(:message) { 'Aaa' * 700 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:message])
          .to include('Message is too long (maximum is 2000 characters)')
      end
    end
  end
end
