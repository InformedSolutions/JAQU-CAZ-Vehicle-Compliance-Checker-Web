# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  def enter_details
    # to be defined later
  end

  def confirm_details
    redirect_to enter_details_vehicle_checkers_path if params[:vrn].blank?
    @vehicle_details = VehicleDetails.new(params[:vrn])
  end
end
