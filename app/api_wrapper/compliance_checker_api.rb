# frozen_string_literal: true

class ComplianceCheckerApi < BaseApi
  base_uri ENV['COMPLIANCE_CHECKER_API_URL'] + '/v1/compliance-checker'

  query_string_normalizer proc { |query|
    query.map do |key, value|
      value.map {|v| "#{key}=#{v}"}
    end.join('&')
  }

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => SecureRandom.uuid
  )

  class << self
    def vehicle_details(vrn)
      request(:get, "/vehicles/#{vrn}/details")
    end

    def vehicle_compliance(vrn, zones)
      request(:get, "/vehicles/#{vrn}/compliance", query: { zones: zones })
    end

    def clean_air_zones
      request(:get, '/clean-air-zones')['cleanAirZones']
    end
  end
end
