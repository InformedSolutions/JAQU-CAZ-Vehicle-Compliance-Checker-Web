# frozen_string_literal: true

class AirZonesController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_error_page

  def caz_selection
    @clean_air_zones = ComplianceCheckerApi.clean_air_zones.map { |caz_data| Caz.new(caz_data) }
  end

  def compliance
    form = CazForm.new(selected_caz)
    unless form.valid?
      return redirect_to caz_selection_air_zones_path(vrn: vrn), alert: form.message
    end

    @compliance_zones = Compliance.new(vrn, selected_caz).compliance_zones
  end

  private

  def vrn
    params[:vrn]
  end

  def selected_caz
    params[:caz]
  end
end
