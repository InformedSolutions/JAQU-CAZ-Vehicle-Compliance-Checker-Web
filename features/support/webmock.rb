# frozen_string_literal: true

require 'webmock/cucumber'

vc_details_response = File.read('spec/fixtures/files/vehicle_details_response.json')
WebMock::API.stub_request(:get, /vehicle_registration/).and_return(body: vc_details_response)
