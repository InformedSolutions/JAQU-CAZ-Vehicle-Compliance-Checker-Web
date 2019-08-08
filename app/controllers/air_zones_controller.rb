# frozen_string_literal: true

class AirZonesController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_error_page
  before_action :vrn, only: %i[caz_selection compliance]

  def caz_selection
    @clean_air_zones = ComplianceCheckerApi.clean_air_zones.map { |caz_data| Caz.new(caz_data) }
  end

  def compliance
    form = CazForm.new(caz)
    return redirect_to caz_selection_air_zones_path, alert: form.message unless form.valid?

    @compliance_zones = Compliance.new(vrn, caz).compliance_zones
    @vrn = vrn
  end

  private

  def caz
    params[:caz]
  end
end
