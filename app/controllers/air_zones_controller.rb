# frozen_string_literal: true

class AirZonesController < ApplicationController
  def caz_selection
    assign_error
    @clean_air_zones = ComplianceCheckerApi::CazList.new.call['zones']
  end

  def compliance
    assign_error
    form = CazForm.new(selected_caz)
    unless form.valid?
      return redirect_to caz_selection_air_zones_path(error: form.message, vrn: vrn)
    end

    @vehicle_details = VehicleDetails.new(vrn)
    @compliance_zones = Compliance.new(vrn, selected_caz).call
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
