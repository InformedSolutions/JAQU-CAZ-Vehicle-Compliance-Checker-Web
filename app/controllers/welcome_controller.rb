# frozen_string_literal: true

##
# Controller class for the home page
#
class WelcomeController < ApplicationController
  ##
  # Renders the home page.
  # It {calls API}[rdoc-ref:ComplianceCheckerApi.clean_air_zones] for the amount of available CAZ.
  #
  # ==== Path
  #    GET /
  #    GET /welcome/index
  #
  # ==== Exceptions
  # Any exception raised during {API call}[rdoc-ref:ComplianceCheckerApi.clean_air_zones]
  # redirects to the {service unavailable page}[rdoc-ref:ErrorsController.service_unavailable]
  #
  def index
    @caz_count = ComplianceCheckerApi.clean_air_zones.size
  end
end
