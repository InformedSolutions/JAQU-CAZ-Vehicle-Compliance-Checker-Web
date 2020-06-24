# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+.
# It's purpose is to be similar to +ComplianceDetails+ class
class NonUkCompliantVehicleDetails
  ##
  # Creates an instance of a class
  #
  # ==== Attributes
  #
  # * +caz_data+ - hash
  #
  def initialize(caz_data)
    @caz_data = caz_data
  end

  # Name of the Clean Air Zone
  # Returns a string, e.g. 'Birmingham'
  def zone_name
    caz_data['name']
  end

  # Stub for .charged? attribute which states if vehicle is chargeable;
  # Compliant non-uk vehicles are not chargeable.
  def charged?
    false
  end

  # Stub for .charge attribute which states how much vehicle is supposed to be charged.
  # Compliant non-uk vehicles are not chargeable.
  def charge
    0
  end

  # Stub for .main_info_url which returns an URL
  # Returns a string, e.g. 'www.example.com'
  def main_info_url
    cazes_main_info_urls[zone_name]
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data['boundaryUrl']
  end

  private

  attr_reader :caz_data

  # The following data are only returned from API response when compliance is actually calculated.
  # As we do not calculate the compliance here, the URLs are hardcoded.
  def cazes_main_info_urls
    {
      'Birmingham' => 'https://www.brumbreathes.co.uk/',
      'Bath' => 'https://www.bathnes.gov.uk/bath-breathes-2021-overview',
      'Leeds' => 'https://www.leeds.gov.uk/business/environmental-health-for-business/air-quality'
    }
  end
end
