# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from InvalidRequestException, with: :redirect_to_back

  def redirect_to_back(exception)
    Rails.logger.error "#{exception.class}: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")

    redirect_to server_unavailable_path
  end

  def server_unavailable
    render 'layouts/server_unavailable'
  end
end
