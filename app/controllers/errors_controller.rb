# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    general_error_response(:not_found, I18n.t('errors.404'))
  end

  def internal_server_error
    general_error_response(:internal_server_error, I18n.t('errors.500'))
  end

  def service_unavailable
    general_error_response(:service_unavailable, I18n.t('errors.503'))
  end

  private

  def general_error_response(status, message)
    respond_to do |format|
      format.xml { render xml: "<error>#{message}</error>", status: status }
      format.html { render(status: status) }
      format.json { render json: { error: message }.to_json, status: status }
    end
  end
end
