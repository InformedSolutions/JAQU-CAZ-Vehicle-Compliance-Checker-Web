# frozen_string_literal: true

##
# Base controller class. Contains rescue block for API errors and common functions.
#
# Also, contains some basic endpoints.
#
class ApplicationController < ActionController::Base
  # protects applications against CSRF
  protect_from_forgery prepend: true
  # rescues from API and security errors
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              InvalidHostException,
              with: :redirect_to_server_unavailable

  # check if host headers are valid
  before_action :validate_host_headers!,
                except: %i[health build_id],
                if: -> { Rails.env.production? && Rails.configuration.x.host.present? }

  # enable basic HTTP authentication on production environment if HTTP_BASIC_PASSWORD variable present
  http_basic_authenticate_with name: ENV['HTTP_BASIC_USER'],
                               password: ENV['HTTP_BASIC_PASSWORD'],
                               except: %i[build_id health],
                               if: lambda {
                                     Rails.env.production? && ENV['HTTP_BASIC_PASSWORD'].present?
                                   }
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
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicle_checkers_path
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end

  # Checks if hosts were not manipulated
  # :nocov:
  def validate_host_headers!
    Security::HostHeaderValidator.call(request: request, allowed_host: Rails.configuration.x.host)
  end
  # :nocov:
end
