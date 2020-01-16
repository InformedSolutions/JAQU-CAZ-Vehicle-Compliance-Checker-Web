# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmDetailsForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:confirm_details) { 'yes' }
  let(:confirm_taxi_or_phv) { 'false' }
  let(:undetermined) { 'false' }
  let(:taxi_or_phv_in_db) { 'false' }
  let(:params) do
    {
      'confirm_details': confirm_details,
      'confirm_taxi_or_phv': confirm_taxi_or_phv,
      'undetermined': undetermined,
      'taxi_or_phv_in_db': taxi_or_phv_in_db
    }
  end

  it { is_expected.to be_valid }

  context 'fields sets as a parameter' do
    %i[confirm_details confirm_taxi_or_phv undetermined taxi_or_phv_in_db].each do |field|
      it "and sets #{field} value" do
        expect(form.public_send(field)).to eq(public_send(field))
      end
    end
  end

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(form.confirmed?).to eq(true)
      end
    end

    context 'when confirm_details equals no' do
      let(:confirm_details) { 'no' }

      it 'returns false' do
        expect(form.confirmed?).to eq(false)
      end
    end
  end

  describe '.undetermined?' do
    context 'when undetermined equals false' do
      it 'returns false' do
        expect(form.undetermined?).to eq(false)
      end
    end

    context 'when undetermined equals true' do
      let(:undetermined) { 'true' }

      it 'returns true' do
        expect(form.undetermined?).to eq(true)
      end
    end
  end

  context 'when confirmation or confirm_taxi_or_phv is empty' do
    %i[confirm_details confirm_taxi_or_phv].each do |field|
      let(field) { '' }

      it { is_expected.not_to be_valid }

      before do
        form.valid?
      end

      it 'has a proper error message' do
        expect(form.errors.messages[field]).to include('You must choose an answer')
      end
    end
  end

  describe '.user_confirms_to_be_taxi?' do
    context 'when user confirms to not be a taxi' do
      context 'and taxi_or_phv_in_db equals false' do
        it 'returns false' do
          expect(form.user_confirms_to_be_taxi?).to eq(false)
        end
      end

      context 'and taxi_or_phv_in_db equals true' do
        let(:taxi_or_phv_in_db) { 'true' }

        it 'returns false' do
          expect(form.user_confirms_to_be_taxi?).to eq(false)
        end
      end
    end

    context 'when user confirms to be a taxi' do
      let(:confirm_taxi_or_phv) { 'true' }

      context 'and taxi_or_phv_in_db equals false' do
        it 'returns true' do
          expect(form.user_confirms_to_be_taxi?).to eq(true)
        end
      end

      context 'and taxi_or_phv_in_db equals true' do
        let(:taxi_or_phv_in_db) { 'true' }

        it 'returns false' do
          expect(form.user_confirms_to_be_taxi?).to eq(false)
        end
      end
    end
  end
end
