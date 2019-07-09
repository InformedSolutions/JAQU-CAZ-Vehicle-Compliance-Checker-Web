# frozen_string_literal: true

module ComplianceCheckerApi
  class Compliance < Base
    URL = '/compliance?vrn='

    def initialize(registration_number, zones)
      @vrn = registration_number.gsub(/\s+/, '')
      @zones = clean_air_zones(zones)
    end

    def call
      raise InvalidRequestException if response.nil?

      response
    end

    def response
      handle_request(URL + @vrn + @zones)
    end

    def clean_air_zones(zones)
      zones.map { |z| "&zones[]=#{z}" }.join('')
    end
  end
end
