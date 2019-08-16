# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found
  before_action :check_vrn, except: %i[enter_details validate_vrn]

  def enter_details
    # renders static page
  end

  def validate_vrn
    form = VrnForm.new(params_vrn, country)
    unless form.valid?
      @error = form.error_object
      return render enter_details_vehicle_checkers_path
    end

    session[:vrn] = params_vrn
    redirect_to non_uk? ? non_uk_vehicle_checkers_path : confirm_details_vehicle_checkers_path
  end

  def confirm_details
    @vehicle_details = VehicleDetails.new(vrn)
    redirect_to exemption_vehicle_checkers_path if @vehicle_details.exempt?
  end

  def user_confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      return redirect_to confirm_details_vehicle_checkers_path, alert: form.message
    end

    redirect_to caz_selection_air_zones_path and return if form.confirmed?
    redirect_to incorrect_details_vehicle_checkers_path
  end

  def incorrect_details
    # to be defined later
  end

  def number_not_found
    @vehicle_registration = vrn
    render(status: :not_found)
  end

  def exemption
    @vehicle_registration = vrn
  end

  def non_uk
    @vehicle_registration = vrn
  end

  private

  def params_vrn
    params[:vrn].upcase
  end

  def confirmation
    params['confirm-vehicle']
  end

  def country
    params['registration-country']
  end

  def non_uk?
    country == 'Non-UK'
  end

  def vehicle_not_found
    redirect_to number_not_found_vehicle_checkers_path
  end
end
