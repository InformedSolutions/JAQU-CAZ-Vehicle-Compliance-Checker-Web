# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @caz_count = ComplianceCheckerApi.clean_air_zones.size
  end
end
