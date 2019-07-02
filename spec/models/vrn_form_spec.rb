# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VrnForm, type: :model do
  subject(:form) { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }

  it 'is valid with a proper VRN' do
    expect(form.valid?).to eq(true)
  end

  it 'has VRN set as parameter' do
    expect(form.parameter).to eq(vrn)
  end

  context 'when VRN is empty' do
    let(:vrn) { '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your registration number')
    end
  end

  context 'when VRN is too long' do
    let(:vrn) { 'ABCDEFGH' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('Your registration number is too long')
    end
  end

  context 'when VRN is too long' do
    let(:vrn) { 'A' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('Your registration number is too short')
    end
  end

  context 'when VRN has wrong format' do
    let(:vrn) { 'ABCDE$%' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must enter your registration number in valid format')
    end
  end
end
