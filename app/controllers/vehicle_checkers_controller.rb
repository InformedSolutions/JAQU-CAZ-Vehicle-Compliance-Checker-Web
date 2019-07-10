# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

  def enter_details
    assign_error
  end

  def confirm_details
    assign_error
    form = VrnForm.new(vrn)
    unless form.valid?
      redirect_to enter_details_vehicle_checkers_path(error: form.message, vrn: vrn)
      return
    end
    @vehicle_details = VehicleDetails.new(vrn)
  end

  def user_confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      redirect_to confirm_details_vehicle_checkers_path(error: form.message, vrn: vrn) and return
    end
    redirect_to caz_selection_air_zones_path(vrn: vrn) and return if form.confirmed?
    redirect_to incorrect_details_vehicle_checkers_path(vrn: vrn)
  end

  def incorrect_details
    # to be defined later
  end

  def number_not_found
    @vehicle_registration = params[:vrn].upcase
  end

  private

  def assign_error
    @error = params[:error]
  end

  def vrn
    params[:vrn]
  end

  def confirmation
    params['confirm-vehicle']
  end

  def vehicle_not_found(exception)
    redirect_to number_not_found_vehicle_checkers_path(vrn: exception.body['registrationNumber'])
  end
end
