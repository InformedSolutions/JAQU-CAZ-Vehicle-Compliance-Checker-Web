# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

  def enter_details
    # renders static page
  end

  def confirm_details
    form = VrnForm.new(vrn)
    unless form.valid?
      return redirect_to enter_details_vehicle_checkers_path(vrn: vrn), alert: form.message
    end

    @vehicle_details = VehicleDetails.new(vrn)
    redirect_to exemption_vehicle_checkers_path(vrn: vrn) if @vehicle_details.exempt?
  end

  def user_confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      return redirect_to confirm_details_vehicle_checkers_path(vrn: vrn), alert: form.message
    end

    redirect_to caz_selection_air_zones_path(vrn: vrn) and return if form.confirmed?
    redirect_to incorrect_details_vehicle_checkers_path(vrn: vrn)
  end

  def incorrect_details
    # to be defined later
  end

  def number_not_found
    @vehicle_registration = vrn.upcase
  end

  def exemption
    @vehicle_registration = vrn.upcase
  end

  private

  def vrn
    params[:vrn]
  end

  def confirmation
    params['confirm-vehicle']
  end

  def vehicle_not_found
    redirect_to number_not_found_vehicle_checkers_path(vrn: vrn)
  end
end
