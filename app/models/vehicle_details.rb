# frozen_string_literal: true

class VehicleDetails
  def initialize(vrn)
    @vrn = vrn.upcase
  end

  def registration_number
    @vrn
  end

  def vrn_for_request
    VrnParser.new(@vrn).call
  end

  def type
    compliance_api['type']
  end

  def make
    compliance_api['make']
  end

  def colour
    compliance_api['colour']
  end

  def fuel_type
    compliance_api['fuelType']
  end

  def taxi_private_hire_vehicle
    compliance_api['isTaxiOrPhv'] ? 'Yes' : 'No'
  end

  def retrofitted?
    compliance_api['isRetrofitted']
  end

  def euro_standard
    compliance_api['euroStatus']
  end

  private

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_details(vrn_for_request)
  end
end
