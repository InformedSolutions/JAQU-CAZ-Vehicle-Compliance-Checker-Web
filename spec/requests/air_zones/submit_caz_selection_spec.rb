# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AirZonesController - POST #submit_caz_selection', type: :request do
  subject(:http_request) { post submit_caz_selection_air_zones_path, params: { caz: caz } }

  let(:caz) { ['a49afb83-d1b3-48b6-b08b-5db8142045dc'] }

  before do
    add_vrn_to_session
    http_request
  end

  it 'redirects to compliance page' do
    expect(response).to redirect_to(compliance_air_zones_path)
  end

  it 'adds checked zones to the session' do
    expect(session[:checked_zones]).to eq(caz)
  end

  context 'when form is invalid' do
    let(:caz) { [] }

    it 'redirects to caz selection page' do
      expect(response).to redirect_to(caz_selection_air_zones_path)
    end
  end
end
