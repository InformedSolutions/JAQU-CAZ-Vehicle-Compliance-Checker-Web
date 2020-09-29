# frozen_string_literal: true

require 'rails_helper'

describe ComplianceCheckerApi do
  subject { described_class.vehicle_compliance(vrn, taxi_or_phv) }

  let(:vrn) { 'CAS310' }
  let(:taxi_or_phv) { false }

  context 'when call returns 200' do
    before do
      vehicle_compliance = file_fixture('vehicle_compliance_response.json').read
      stub_request(:get, /compliance/).to_return(status: 200, body: vehicle_compliance)
    end

    it 'returns registration number' do
      expect(subject['registrationNumber']).to eq(vrn)
    end

    it 'returns if PHGV discount is available' do
      expect(subject['phgvDiscountAvailable']).to be_truthy
    end

    it 'returns compliance data for all zones' do
      expect(subject['complianceOutcomes'][0].keys).to contain_exactly(
        'cleanAirZoneId', 'charge', 'name', 'operatorName', 'informationUrls', 'tariffCode'
      )
    end

    context 'subjects API with right params' do
      RSpec.shared_examples_for 'uri have the proper query params' do
        it 'equals query params' do
          expect(WebMock).to(have_requested(:get, /compliance/)
            .with { |req| req.uri.query == query })
        end
      end

      before { subject }

      context 'when taxi_or_phv is false' do
        let(:query) { nil }

        it_behaves_like 'uri have the proper query params'
      end

      context 'when taxi_or_phv is true' do
        let(:taxi_or_phv) { true }
        let(:query) { "isTaxiOrPhv=#{taxi_or_phv}" }

        it_behaves_like 'uri have the proper query params'
      end
    end
  end

  context 'when subject returns 500' do
    before do
      stub_request(:get, /compliance/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end

  context 'when subject returns 400' do
    before do
      stub_request(:get, /compliance/).to_return(
        status: 400,
        body: { 'message' => 'Correlation ID is missing' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when subject returns 404' do
    before do
      stub_request(:get, /compliance/).to_return(
        status: 404,
        body: { 'message' => "Vehicle with registration number #{vrn} was not found" }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when subject returns 422' do
    before do
      stub_request(:get, /compliance/).to_return(
        status: 422,
        body: { 'message' => "#{vrn} is an invalid registration number" }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
