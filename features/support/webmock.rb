# frozen_string_literal: true

require 'webmock/cucumber'

vc_details_response = File.read('spec/fixtures/files/vehicle_details_response.json')
WebMock::API.stub_request(:get, /vehicle_registration/).and_return(body: vc_details_response)

caz_list_response = File.read('spec/fixtures/files/caz_list_response.json')
WebMock::API.stub_request(:get, /clean_air_zones/).to_return(
  body: caz_list_response,
  headers: { 'Content-Type' => 'application/json' }
)
