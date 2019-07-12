# frozen_string_literal: true

class AirZonesController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_error_page

  def caz_selection
    assign_error
    @clean_air_zones = ComplianceCheckerApi.clean_air_zones
  end

  def compliance
    assign_error
    form = CazForm.new(selected_caz)
    unless form.valid?
      return redirect_to caz_selection_air_zones_path(error: form.message, vrn: vrn)
    end

    @compliance = Compliance.new(vrn, selected_caz)
    @compliance_zones = @compliance.compliance_zones
  end

  private

  def assign_error
    @error = params[:error]
  end

  def vrn
    params[:vrn]
  end

  def selected_caz
    params[:caz]
  end
end
