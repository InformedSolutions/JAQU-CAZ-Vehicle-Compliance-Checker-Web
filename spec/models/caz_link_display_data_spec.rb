# frozen_string_literal: true

require 'rails_helper'

describe CazLinkDisplayData, type: :model do
  describe '.from_list' do
    subject { described_class.from_list(caz_list) }

    let(:caz_list) { read_response('caz_list_response.json')['cleanAirZones'] }

    it 'returns collection of CAZ data' do
      expect(subject.count).to eq(3)
    end

    it "returns an array of #{described_class}" do
      expect(subject).to all(be_a(described_class))
    end
  end
end
