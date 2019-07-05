# frozen_string_literal: true

module ComplianceCheckerApi
  class CazList < Base
    URL = '/clean_air_zones'

    def call
      raise InvalidRequestException if response.nil?

      response
    end

    def response
      handle_request(URL)
    end
  end
end
