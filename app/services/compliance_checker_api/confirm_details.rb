# frozen_string_literal: true

module ComplianceCheckerApi
  class ConfirmDetails < Base
    URL = '?vehicle_registration='

    def initialize(registration_number)
      @vrn = registration_number.gsub(/\s+/, '')
    end

    def call
      self.class.get(URL + @vrn).parsed_response
    end
  end
end
