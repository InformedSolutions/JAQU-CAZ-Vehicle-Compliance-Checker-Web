# frozen_string_literal: true

class ComplianceCheckerApi < BaseApi
  base_uri ENV['COMPLIANCE_CHECKER_API_URL'] + '/v1/compliance-checker'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => SecureRandom.uuid
  )

  class << self
    def vehicle_details(vrn)
      log_action "Getting vehicle details, vrn: #{vrn}"
      request(:get, "/vehicles/#{vrn}/details")
    end

    def vehicle_compliance(vrn, zones)
      zones = zones.join(',')
      log_action "Getting vehicle compliance, vrn: #{vrn}, zones: #{zones}"
      request(:get, "/vehicles/#{vrn}/compliance", query: { zones: zones })
    end

    def clean_air_zones
      log_action 'Getting clean air zones'
      request(:get, '/clean-air-zones')['cleanAirZones']
    end
  end
end
