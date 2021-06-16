# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/compliance.html.haml+ for non-uk vehicles.
#
class CleanAirZone
  # Fetches cazes and filter out which should not be displayed.
  def visible_cazes
    all.reject { |caz| display_from_in_future?(caz['displayFrom']) }
       .map { |caz| NonUkCompliantVehicleDetails.new(caz) }
  end

  private

  # Fetches all available cazes.
  def all
    ComplianceCheckerApi.clean_air_zones
  end

  # Checks if date is not in the future.
  def display_from_in_future?(date)
    Date.parse(date).future?
  end
end
