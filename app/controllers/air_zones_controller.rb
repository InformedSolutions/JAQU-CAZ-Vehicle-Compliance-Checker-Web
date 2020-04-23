# frozen_string_literal: true

##
# Controller class for 2 final steps of checking the vehicle compliance
#
class AirZonesController < ApplicationController
  # rescues also from 404 -> the rest is in ApplicationController
  rescue_from BaseApi::Error404Exception, with: :redirect_to_server_unavailable
  # 422 HTTP status from API means vehicle data incomplete so the compliance calculation is not possible.
  rescue_from BaseApi::Error422Exception, with: :unable_to_determine_compliance

  # checks if vrn is present in the session
  before_action :check_vrn

  ##
  # Renders a result of checking compliance of the vehicle against selected CAZ.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance] for the results.
  #
  # ==== Path
  #    GET /air_zones/compliance
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +caz+ - list of the selected CAZ ids, required in the query params
  # * +taxi_or_phv+ - boolean, user confirms to be a taxi.
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.vehicle_compliance]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def compliance
    @compliance_outcomes = Compliance.new(vrn, caz, session[:taxi_or_phv]).compliance_outcomes
    @vrn = vrn
  end

  private

  # Returns a list of Clean Air Zones from session
  def caz
    # Hardcoded Birmingham zone id which will be updated in the next card https://eaflood.atlassian.net/browse/CAZB-1096
    ['5cd7441d-766f-48ff-b8ad-1809586fea37']
  end

  # Redirects to 'Unable to determine compliance' page
  def unable_to_determine_compliance
    redirect_to cannot_determine_vehicle_checkers_path
  end
end
