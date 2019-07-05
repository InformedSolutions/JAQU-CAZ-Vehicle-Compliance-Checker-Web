# frozen_string_literal: true

module ComplianceCheckerApi
  class Base
    include HTTParty
    base_uri(ENV['COMPLIANCE_CHECKER_API_URL'])

    def handle_request(url)
      begin
        self.class.get(url).parsed_response
      rescue
        nil
      end
    end
  end
end
