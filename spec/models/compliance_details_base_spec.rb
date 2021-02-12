# frozen_string_literal: true

require 'rails_helper'

describe ComplianceDetailsBase, type: :model do
  subject { ComplianceDetails.new(details, false) }

  let(:details) do
    {
      'name' => name,
      'operatorName' => 'Birmingham City Council',
      'charge' => 5.1,
      'informationUrls' => {
        'boundary' => 'www.example.com',
        'mainInfo' => 'www.example.com',
        'publicTransportOptions' => 'www.example.com',
        'exemptionOrDiscount' => 'www.example.com',
        'becomeCompliant' => 'www.example.com'
      }
    }
  end

  let(:name) { 'Birmingham' }

  describe '.charging_starts' do
    context 'when caz name is Birmingham' do
      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('1 June 2021')
      end
    end

    context 'when caz name is Bath' do
      let(:name) { 'Bath' }

      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('15 March 2021')
      end
    end

    context 'when another caz name' do
      let(:name) { 'Leeds' }

      it 'returns a proper value' do
        expect(subject.charging_starts).to eq('Early 2021')
      end
    end
  end
end
