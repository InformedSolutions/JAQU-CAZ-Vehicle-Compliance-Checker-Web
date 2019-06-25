# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  def enter_details
    # to be defined later
  end

  def confirm_details
    redirect_to enter_details_vehicle_checkers_path if params[:vrn].blank?
    @vehicle_details = VehicleDetails.new(params[:vrn])
  end

  def user_confirm_details
    if params['confirm-vehicle'].present?
      if params['confirm-vehicle'] == 'yes'
        redirect_to enter_details_vehicle_checkers_path
      else
        redirect_to incorrect_details_vehicle_checkers_path
      end
    else
      redirect_to enter_details_vehicle_checkers_path
    end
  end

  def incorrect_details
    # to be defined later
  end
end
