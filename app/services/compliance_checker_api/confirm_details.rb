# frozen_string_literal: true

module ComplianceCheckerApi
  class ConfirmDetails < Base
    URL = '/check_vehicle_registration?vehicle_registration='

    def initialize(registration_number)
      @vrn = registration_number.gsub(/\s+/, '')
    end

    def call
      raise InvalidRequestException if response.nil?

      response
    end

    def response
      self.class.get(URL + @vrn).parsed_response
    end
  end
end
