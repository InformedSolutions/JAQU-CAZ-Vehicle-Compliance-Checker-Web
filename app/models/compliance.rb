# frozen_string_literal: true

class Compliance
  def initialize(vrn, zones)
    @vrn = vrn.upcase
    @zones = zones
  end

  def compliance_zones
    @compliance_zones ||= compliance_api['complianceOutcomes'].map { |v| ComplianceDetails.new(v) }
  end

  private

  def vrn_for_request
    VrnParser.new(@vrn).call
  end

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_compliance(vrn_for_request, @zones)
  end
end
