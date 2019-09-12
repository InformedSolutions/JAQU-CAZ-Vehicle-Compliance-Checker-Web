# frozen_string_literal: true

##
# Controller class for first steps of checking the vehicle compliance
#
class VehicleCheckersController < ApplicationController
  # 404 HTTP status from API mean vehicle in not found in DLVA database. Redirects to the proper page.
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

  # checks if VRN is present in the session
  before_action :check_vrn, except: %i[enter_details validate_vrn]

  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicle_checkers/enter_details
  #
  def enter_details
    @errors = {}
  end

  ##
  # Validates submitted VRN. If successful, adds submitted VRN to the session and
  # redirects to {confirm details}[rdoc-ref:VehicleCheckersController.confirm_details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehicleCheckersController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicle_checkers/validate_vrn
  #
  # GET method redirects to {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  # * +registration-country+ - country of the vehicle registration, UK or NON-UK, required in the query
  #
  # ==== Validations
  # Validations are done by {VrnForm}[rdoc-ref:VrnForm]
  #
  def validate_vrn
    form = VrnForm.new(params_vrn, country)
    unless form.valid?
      @errors = form.error_object
      return render enter_details_vehicle_checkers_path
    end

    session[:vrn] = params_vrn
    redirect_to non_uk? ? non_uk_vehicle_checkers_path : confirm_details_vehicle_checkers_path
  end

  ##
  # Renders vehicle details form.
  # To do it, performs {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_details] for given VRN
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - vehicle not found in the DVLA db - redirects to {number not found}[rdoc-ref:VehicleCheckersController.number_not_found]
  # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid VRN - redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error - redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  #
  # Other connection exceptions also redirects to {service unavailable}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def confirm_details
    @vehicle_details = VehicleDetails.new(vrn)
    redirect_to exemption_vehicle_checkers_path if @vehicle_details.exempt?
  end

  ##
  # Verifies if user confirms data returned from the API.
  # If yes, redirects to {the next step}[rdoc-ref:AirZonesController.caz_selection] of the checking compliance process.
  # If no, redirects to {incorrect details}[rdoc-ref:VehicleCheckersController.incorrect_details]
  #
  # ==== Path
  #    GET /vehicle_checkers/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects back to {confirm details}[rdoc-ref:VehicleCheckersController.confirm_details]
  #
  def user_confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      return redirect_to confirm_details_vehicle_checkers_path, alert: form.message
    end

    redirect_to caz_selection_air_zones_path and return if form.confirmed?
    redirect_to incorrect_details_vehicle_checkers_path
  end

  ##
  # Renders a static page for users who selected that DVLA data in incorrect
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def incorrect_details
    # to be defined later
  end

  ##
  # Renders a page for not found vehicles. Returns HTTP status 404 (not found)
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/number_not_found
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def number_not_found
    @vehicle_registration = vrn
    render(status: :not_found)
  end

  ##
  # Renders a page for vehicles exempt from the charges in all CAZs.
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/exemption
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def exemption
    @vehicle_registration = vrn
  end

  ##
  # Renders a page for vehicles that are not registered within the UK
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/non_uk
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def non_uk
    @vehicle_registration = vrn
  end

  private

  # Returns uppercased VRN from the query params, eg. 'CU1234'
  def params_vrn
    params[:vrn].upcase
  end

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle']
  end

  # Returns vehicles's registration country from the query params, values: 'UK', 'Non-UK', nil
  def country
    params['registration-country']
  end

  # Checks if selected registration country equals Non-UK.
  # Returns boolean.
  def non_uk?
    country == 'Non-UK'
  end

  # Redirects to {number not found}[rdoc-ref:VehicleCheckersController.number_not_found]
  def vehicle_not_found
    redirect_to number_not_found_vehicle_checkers_path
  end
end
