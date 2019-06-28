# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  def enter_details
    # to be defined later
  end

  def confirm_details
    redirect_to enter_details_vehicle_checkers_path if params[:vrn].blank?

    @vehicle_details = VehicleDetails.new(params[:vrn])
    if @vehicle_details.error == 'Vehicle registration not found'
      redirect_to number_not_found_vehicle_checkers_path(vrn: params[:vrn])
    end
  end

  def user_confirm_details
    if params['confirm-vehicle'] == 'yes'
      # TO DO: Change after implementation vehicle_checker/local-authority
      redirect_to enter_details_vehicle_checkers_path
    else
      redirect_to incorrect_details_vehicle_checkers_path
    end
  end

  def incorrect_details
    # to be defined later
  end

  def number_not_found
    @vehicle_registration = params[:vrn].upcase
  end
end
