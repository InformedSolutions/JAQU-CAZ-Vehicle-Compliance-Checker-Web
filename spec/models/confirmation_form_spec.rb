# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmationForm, type: :model do
  subject(:form) { described_class.new(confirmation) }

  let(:confirmation) { 'yes' }

  it 'is valid with a proper confirmation' do
    expect(form.valid?).to eq(true)
  end

  it 'has confirmation set as parameter' do
    expect(form.parameter).to eq(confirmation)
  end

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(form.confirmed?).to eq(true)
      end
    end

    context 'when confirmation equals no' do
      let(:confirmation) { 'no' }

      it 'returns false' do
        expect(form.confirmed?).to eq(false)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.message).to eq('You must choose an answer')
    end
  end
end
