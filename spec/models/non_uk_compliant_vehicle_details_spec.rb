# frozen_string_literal: true

require 'rails_helper'

describe NonUkCompliantVehicleDetails, type: :model do
  subject { described_class.new(caz_data) }

  let(:caz_data) do
    {
      'name' => name,
      'operatorName' => operator_name,
      'boundaryUrl' => url,
      'mainInfoUrl' => url,
      'exemptionUrl' => url,
      'displayFrom' => display_from,
      'displayOrder' => display_order,
      'activeChargeStartDate' => active_charge_start_date,
      'activeChargeStartDateText' => active_charge_start_date_text
    }
  end

  let(:name) { 'Birmingham' }
  let(:operator_name) { 'Birmingham City Council' }
  let(:url) { 'www.example.com' }
  let(:display_from) { '2022-01-01' }
  let(:display_order) { 1 }
  let(:active_charge_start_date) { '2023-01-01' }
  let(:active_charge_start_date_text) { 'Q1 2023' }

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
      expect(subject.main_info_url).to eq(url)
    end
  end

  describe '.boundary_url' do
    it 'returns proper .boundary_url value' do
      expect(subject.boundary_url).to eq(url)
    end
  end

  describe '.exemption_or_discount_url' do
    it 'return proper .exemption_or_discount_url value' do
      expect(subject.exemption_or_discount_url).to eq(url)
    end
  end

  describe '.operator_name' do
    it 'returns a proper value' do
      expect(subject.operator_name).to eq(operator_name)
    end
  end

  describe '.display_from' do
    it 'returns a proper value' do
      expect(subject.display_from).to eq(Date.parse(display_from))
    end
  end

  describe '.display_order' do
    it 'returns a proper value' do
      expect(subject.display_order).to eq(display_order)
    end
  end

  describe '.active_charge_start_date' do
    it 'returns a proper value' do
      expect(subject.active_charge_start_date).to eq(Date.parse(active_charge_start_date))
    end
  end

  describe '.active_charge_start_date_text' do
    it 'returns a proper value' do
      expect(subject.active_charge_start_date_text).to eq(active_charge_start_date_text)
    end
  end
end
