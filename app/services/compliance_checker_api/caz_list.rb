# frozen_string_literal: true

module ComplianceCheckerApi
  class CazList < Base
    URL = '/clean_air_zones'

    def call
      raise InvalidRequestException if response.nil?

      response
    end

    def response
      self.class.get(URL).parsed_response
    end
  end
end
