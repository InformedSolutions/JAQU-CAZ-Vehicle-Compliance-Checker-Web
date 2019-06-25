# frozen_string_literal: true

module ComplianceCheckerApi
  class Base
    include HTTParty
    base_uri(ENV['COMPLIANCE_CHECKER_API_URL'])
  end
end
