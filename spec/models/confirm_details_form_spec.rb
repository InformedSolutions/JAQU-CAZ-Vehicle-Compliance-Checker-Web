# frozen_string_literal: true

require 'rails_helper'

describe ConfirmDetailsForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:confirm_details) { 'yes' }
  let(:confirm_taxi_or_phv) { 'false' }
  let(:undetermined) { 'false' }
  let(:taxi_and_correct_type) { 'true' }
  let(:params) do
    {
      'confirm_details': confirm_details,
      'confirm_taxi_or_phv': confirm_taxi_or_phv,
      'undetermined': undetermined,
      'taxi_and_correct_type': taxi_and_correct_type
    }
  end

  it { is_expected.to be_valid }

  context 'fields sets as a parameter' do
    %i[confirm_details confirm_taxi_or_phv undetermined taxi_and_correct_type].each do |field|
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

  context 'when confirmation is empty' do
    let(:confirm_details) { '' }

    it { is_expected.not_to be_valid }

    before do
      form.valid?
    end

    it 'has a proper error message' do
      expect(form.errors.messages[:confirm_details])
        .to include('Select yes if the details are correct')
    end
  end

  context 'when confirm_taxi_or_phv is empty' do
    let(:confirm_taxi_or_phv) { '' }

    it { is_expected.not_to be_valid }

    before do
      form.valid?
    end

    it 'has a proper error message' do
      expect(form.errors.messages[:confirm_taxi_or_phv]).to include('You must choose an answer')
    end
  end

  describe '.user_confirms_to_be_taxi?' do
    context 'when user confirms to not be a taxi' do
      context 'and taxi_and_correct_type equals false' do
        it 'returns false' do
          expect(form.user_confirms_to_be_taxi?).to eq(false)
        end
      end

      context 'and taxi_and_correct_type equals true' do
        let(:taxi_and_correct_type) { 'true' }

        it 'returns false' do
          expect(form.user_confirms_to_be_taxi?).to eq(false)
        end
      end
    end

    context 'when user confirms to be a taxi' do
      let(:confirm_taxi_or_phv) { 'true' }

      context 'and taxi_and_correct_type equals false' do
        it 'returns true' do
          expect(form.user_confirms_to_be_taxi?).to eq(true)
        end
      end

      context 'and taxi_and_correct_type equals true' do
        let(:taxi_and_correct_type) { 'true' }

        it 'returns true' do
          expect(form.user_confirms_to_be_taxi?).to eq(true)
        end
      end
    end
  end
end
