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
    string_field('type')
  end

  def make
    string_field('make')
  end

  def colour
    string_field('colour')
  end

  def fuel_type
    string_field('fuelType')
  end

  def taxi_private_hire_vehicle
    compliance_api['taxiOrPhv'] ? 'Yes' : 'No'
  end

  def exempt?
    compliance_api['exempt']
  end

  private

  def string_field(key)
    compliance_api[key]&.capitalize
  end

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_details(vrn_for_request)
  end
end
