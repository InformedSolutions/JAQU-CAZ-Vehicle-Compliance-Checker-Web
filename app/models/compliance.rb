# frozen_string_literal: true

class Compliance
  def initialize(vrn, zones)
    @vrn = vrn.upcase
    @zones = zones
  end

  def compliance_outcome
    @compliance_outcome ||= compliance_api['complianceOutcomes'].map do |v|
      ComplianceDetails.new(v)
    end
  end

  private

  def vrn_for_request
    VrnParser.new(@vrn).call
  end

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_compliance(vrn_for_request, @zones)
  end
end
