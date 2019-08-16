# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              with: :redirect_to_server_unavailable

  def health
    render json: 'OK', status: :ok
  end

  def build_id
    render json: ENV.fetch('BUILD_ID', 'undefined'), status: :ok
  end

  private

  def redirect_to_server_unavailable(exception)
    Rails.logger.error "#{exception.class}: #{exception.message}"

    render template: 'errors/service_unavailable', status: :service_unavailable
  end

  def check_vrn
    redirect_to enter_details_vehicle_checkers_path unless vrn
  end

  def vrn
    session[:vrn]
  end
end
