# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CazForm, type: :model do
  subject(:form) { described_class.new(selected_caz) }

  let(:selected_caz) { %w[London York] }

  it 'is valid with a proper selected caz' do
    expect(form.valid?).to eq(true)
  end

  it 'has selected caz set as parameter' do
    expect(form.parameter).to eq(selected_caz)
  end

  context 'when selected caz is empty' do
    let(:selected_caz) { '' }

    it 'is not valid' do
      expect(form.valid?).to eq(false)
    end

    it 'has a proper error message' do
      expect(form.message).to eq('You must choose clean air zones')
    end
  end
end
