# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NonUkCompliantVehicleDetails, type: :model do
  subject { described_class.new(caz_data) }

  let(:caz_data) do
    {
      'name' => name,
      'boundaryUrl' => boundary_url
    }
  end

  let(:name) { 'Birmingham' }
  let(:boundary_url) { 'www.example.com' }

  describe '.zone_name' do
    it 'returns proper .zone_name value' do
      expect(subject.zone_name).to eq(name)
    end
  end

  describe '.charged?' do
    it 'returns proper .charged? value' do
      expect(subject.charged?).to eq(false)
    end
  end

  describe '.charge' do
    it 'returns proper .charge value' do
      expect(subject.charge).to eq(0)
    end
  end

  describe '.main_info_url' do
    it 'returns proper .main_info_url value' do
      expect(subject.main_info_url)
        .to eq('https://www.brumbreathes.co.uk/')
    end
  end

  describe '.boundary_url' do
    it 'returns proper .boundary_url value' do
      expect(subject.boundary_url).to eq(boundary_url)
    end
  end
end
