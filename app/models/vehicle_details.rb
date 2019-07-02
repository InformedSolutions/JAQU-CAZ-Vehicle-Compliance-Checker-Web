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
    compliance_api['fuel_type']
  end

  def taxi_private_hire_vehicle
    compliance_api['taxi_private_hire_vehicle'] ? 'Yes' : 'No'
  end

  def euro_standard
    compliance_api['euro_standard']
  end

  def error
    compliance_api['message']
  end

  private

  def compliance_api
    @compliance_api ||= ComplianceCheckerApi::ConfirmDetails.new(vrn_for_request).call
  end
end
