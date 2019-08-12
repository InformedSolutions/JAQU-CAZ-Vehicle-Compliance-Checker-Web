# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Compliance, type: :model do
  subject(:compliance) { described_class.new(vrn, zones) }
  let(:vrn) { 'cu1234' }
  let(:transformed_vrn) { 'CU-1234' }
  let(:zones) { %w[zone1 zone2] }

  before do
    compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
    allow(VrnParser).to receive(:call).and_return(transformed_vrn)
  end

  describe '.compliance_outcomes' do
    let(:outcomes) { compliance.compliance_outcomes }

    it 'calls VrnParser' do
      expect(VrnParser).to receive(:call).with(vrn: vrn.upcase)
      outcomes
    end

    it 'calls ComplianceCheckerApi' do
      expect(ComplianceCheckerApi)
        .to receive(:vehicle_compliance)
        .with(transformed_vrn, zones)
      outcomes
    end

    it 'returns an array of ComplianceDetails' do
      expect(outcomes).to all(be_an(ComplianceDetails))
    end
  end
end
