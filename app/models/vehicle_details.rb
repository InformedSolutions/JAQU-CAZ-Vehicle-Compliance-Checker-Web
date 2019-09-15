# frozen_string_literal: true

##
# This class represents data returned by {CAZ API endpoint}[rdoc-ref:ComplianceCheckerApi.vehicle_details]
# and is used to display data in +app/views/vehicle_checkers/confirm_details.html.haml+.
class VehicleDetails
  ##
  # Creates an instance of a class, make +vrn+ uppercase and remove all spaces.
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  def initialize(vrn)
    @vrn = vrn.upcase.gsub(/\s+/, '')
  end

  # Returns a string, eg. 'CU57ABC'.
  def registration_number
    @vrn
  end

  # Returns a string, eg. 'CU57ABC'.
  def vrn_for_request
    VrnParser.call(vrn: @vrn)
  end

  # Returns a string, eg. 'Car'.
  def type
    string_field('type')
  end

  # Returns a string, eg. 'Peugeot'.
  def make
    string_field('make')
  end

  # Returns a string, eg. 'Grey'.
  def colour
    string_field('colour')
  end

  # Returns a string, eg. 'Diesel'.
  def fuel_type
    string_field('fuelType')
  end

  # Check 'taxiOrPhv' value.
  #
  # Returns a string 'Yes' if value is true.
  # Returns a string 'No' if value is false.
  def taxi_private_hire_vehicle
    compliance_api['taxiOrPhv'] ? 'Yes' : 'No'
  end

  # Check 'exempt' key.
  #
  # Returns a boolean 'true' if key is present.
  # Returns a nil if key is not present.
  def exempt?
    compliance_api['exempt']
  end

  # Returns a string, eg. 'M1'.
  def type_approval
    string_field('typeApproval')
  end

  # Returns a string, eg. 'i20'.
  def model
    string_field('model')
  end

  private

  ##
  # Converts the first character of +key+ value to uppercase.
  #
  # ==== Attributes
  #
  # * +key+ - string, eg. 'type'
  #
  # ==== Result
  # Returns a nil if +key+ value is blank or equal to 'null'.
  # Returns a string, eg. 'Car' if +key+ value is present.
  # Returns a nil if +key+ value is not present.
  def string_field(key)
    return nil if compliance_api[key].blank? || compliance_api[key].downcase == 'null'

    compliance_api[key]&.capitalize
  end

  ##
  # Calls +/v1/compliance-checker/vehicles/:vrn/compliance+ endpoint with +GET+ method
  # and returns compliance details of the requested vehicle for requested zones.
  #
  # ==== Result
  #
  # Returned compliance details will have following fields:
  # * +registrationNumber+ - string, eg. 'CAS310'
  # * +retrofitted+ - boolean
  # * +exempt+ - boolean, determines if the vehicle is exempt from charges
  # * +complianceOutcomes+ - array of objects
  #   * +cleanAirZoneId+ - UUID, this represents CAZ ID in the DB
  #   * +name+ - string, eg. 'Birmingham'
  #   * +charge+ - number, determines how much owner of the vehicle will have to pay in this CAZ
  #   * +informationUrls+ - object containing CAZ dedicated info links
  #     * +emissionsStandards+
  #     * +mainInfo+
  #     * +hoursOfOperation+
  #     * +pricing+
  #     * +exemptionOrDiscount+
  #     * +payCaz+
  #     * +becomeCompliant+
  #     * +financialAssistance+
  #     * +boundary+
  def compliance_api
    @compliance_api ||= ComplianceCheckerApi.vehicle_details(vrn_for_request)
  end
end
