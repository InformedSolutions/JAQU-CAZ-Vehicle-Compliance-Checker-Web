# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Compliance, type: :model do
  subject(:compliance) { described_class.new(vrn, taxi_or_phv) }
  let(:vrn) { 'CU1234' }
  let(:taxi_or_phv) { false }

  before do
    compliance = JSON.parse(file_fixture('vehicle_compliance_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance)
  end

  describe '.compliance_outcomes' do
    let(:outcomes) { compliance.compliance_outcomes }

    it 'calls ComplianceCheckerApi' do
      expect(ComplianceCheckerApi)
        .to receive(:vehicle_compliance)
        .with(vrn, taxi_or_phv)
      outcomes
    end

    it 'returns an array of ComplianceDetails' do
      expect(outcomes).to all(be_an(ComplianceDetails))
    end
  end
end
