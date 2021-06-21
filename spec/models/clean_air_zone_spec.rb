# frozen_string_literal: true

require 'rails_helper'

describe CleanAirZone, type: :model do
  let(:caz_list_response) { read_response('caz_list_response.json')['cleanAirZones'] }

  before { allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list_response) }

  describe '.visible_cazes' do
    subject(:visible_cazes) { described_class.new.visible_cazes }

    it 'returns only visible clean air zones' do
      expect(visible_cazes.count).to eq(2)
    end

    it 'returns an array of `NonUkCompliantVehicleDetails` instances' do
      expect(visible_cazes).to all(be_an(NonUkCompliantVehicleDetails))
    end
  end
end
