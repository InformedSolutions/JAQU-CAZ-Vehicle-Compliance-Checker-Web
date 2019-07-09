# frozen_string_literal: true

class Compliance
  def initialize(vrn, zones)
    @vrn = vrn.upcase
    @zones = zones
  end

  def vrn_for_request
    VrnParser.new(@vrn).call
  end

  def call
    compliance_zones
  end

  private

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi::Compliance.new(vrn_for_request, @zones).call
  end

  def compliance_zones
    @compliance_zones ||= []
    return @compliance_zones if @compliance_zones.present?

    compliance_api['compliance'].each { |_k, v| @compliance_zones << v }
    @compliance_zones
  end
end
