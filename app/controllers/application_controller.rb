# frozen_string_literal: true

##
# Base controller class. Contains rescue block for API errors and common functions.
#
# Also, contains some basic endpoints.
#
class ApplicationController < ActionController::Base
  # rescues from API errors
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              with: :redirect_to_server_unavailable

  ##
  # Health endpoint
  #
  # Used as a healthcheck - returns 200 HTTP status
  #
  # ==== Path
  #
  #    GET /health.json
  #
  def health
    render json: 'OK', status: :ok
  end

  ##
  # Build ID endpoint
  #
  # Used by CI to determine if the new version is already deployed.
  # +BUILD_ID+ environment variables is used to set it's value. If nothing is set, returns 'undefined
  #
  # ==== Path
  #
  #    GET /build_id.json
  #
  def build_id
    render json: ENV.fetch('BUILD_ID', 'undefined'), status: :ok
  end

  private

  # Function used as a rescue from API errors.
  # Logs the exception and redirects to ErrorsController#service_unavailable
  def redirect_to_server_unavailable(exception)
    Rails.logger.error "#{exception.class}: #{exception}"

    render template: 'errors/service_unavailable', status: :service_unavailable
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehicleCheckersController#enter_details
  def check_vrn
    redirect_to enter_details_vehicle_checkers_path unless vrn
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end
end
