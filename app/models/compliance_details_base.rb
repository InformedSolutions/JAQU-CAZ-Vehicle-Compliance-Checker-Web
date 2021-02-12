# frozen_string_literal: true

##
# This module is used to display data in +app/views/air_zones/compliance.html.haml+.
module ComplianceDetailsBase
  # Depend on CAZ name returns proper date
  # Returns a string, e.g. '15 March 2021'
  def charging_starts
    case zone_name
    when 'Bath'
      '15 March 2021'
    when 'Birmingham'
      '1 June 2021'
    else
      'Early 2021'
    end
  end
end
