# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              with: :redirect_to_error_page

  def server_unavailable
    render 'layouts/server_unavailable'
  end

  def health
    render json: 'OK', status: 200
  end

  private

  def redirect_to_error_page(exception)
    Rails.logger.error "#{exception.class}: #{exception.message}"

    redirect_to server_unavailable_path
  end
end
