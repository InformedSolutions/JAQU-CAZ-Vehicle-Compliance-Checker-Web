# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  def enter_details
    @error = params[:error]
  end

  def confirm_details
    @error = params[:error]
    form = VrnForm.new(vrn)
    unless form.valid?
      redirect_to enter_details_vehicle_checkers_path(error: form.message, vrn: vrn)
      return
    end
    @vehicle_details = VehicleDetails.new(vrn)
    if @vehicle_details.error == 'Vehicle registration not found'
      redirect_to number_not_found_vehicle_checkers_path(vrn: params[:vrn])
    end
  end

  def user_confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      redirect_to confirm_details_vehicle_checkers_path(error: form.message, vrn: vrn) and return
    end
    redirect_to enter_details_vehicle_checkers_path and return if form.confirmed?
    redirect_to incorrect_details_vehicle_checkers_path(vrn: vrn)
  end

  def incorrect_details
    # to be defined later
  end

  def number_not_found
    @vehicle_registration = params[:vrn].upcase
  end

  private

  def vrn
    params[:vrn]
  end

  def confirmation
    params['confirm-vehicle']
  end
end
