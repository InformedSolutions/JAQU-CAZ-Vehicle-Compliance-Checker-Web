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

  # Stub for .charge attribute which states how much vehicle is supposed to be charged.
  # Compliant non-uk vehicles are not chargeable.
  def charge_amount
    0
  end

  # Returns a string, e.g. 'www.example.com'
  def main_info_url
    caz_data['mainInfoUrl']
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data['boundaryUrl']
  end

  # Returns a string, eg. 'www.example.com'
  def exemption_or_discount_url
    caz_data['exemptionUrl']
  end

  # Returns a string, eg. 'Bath and North East Somerset Council'
  def operator_name
    caz_data['operatorName']
  end

  # The date which specifies since when the CAZ should be visible on the page.
  # Returns a date, eg. '2021-03-21'
  def display_from
    Date.parse(caz_data['displayFrom'])
  end

  # Information about CAZ ordering.
  # Returns an integer, eg. 2
  def display_order
    caz_data['displayOrder']
  end

  # Date when charging in the specific CAZ starts.
  # Returns a date, eg. '2021-03-21'
  def active_charge_start_date
    Date.parse(caz_data['activeChargeStartDate'])
  end

  # Text which is going to be displayed when charging start date is not known yet.
  # Returns a string, eg. 'Summer 2022'
  def active_charge_start_date_text
    caz_data['activeChargeStartDateText']
  end

  private

  attr_reader :caz_data
end
