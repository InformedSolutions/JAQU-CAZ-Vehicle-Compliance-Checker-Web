# frozen_string_literal: true

class VehicleDetails
  def initialize(vrn)
    @vrn = vrn.upcase.gsub(/\s+/, '')
  end

  def registration_number
    @vrn
  end

  def vrn_for_request
    VrnParser.call(vrn: @vrn)
  end

  def type
    compliance_api['type'].capitalize
  end

  def make
    compliance_api['make'].capitalize
  end

  def colour
    compliance_api['colour'].capitalize
  end

  def fuel_type
    compliance_api['fuelType'].capitalize
  end

  def taxi_private_hire_vehicle
    compliance_api['isTaxiOrPhv'] ? 'Yes' : 'No'
  end

  def exempt?
    compliance_api['isExempt']
  end

  private

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_details(vrn_for_request)
  end
end
