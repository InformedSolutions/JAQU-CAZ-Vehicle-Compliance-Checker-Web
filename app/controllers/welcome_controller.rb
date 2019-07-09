# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @clean_air_zones_count = ComplianceCheckerApi::CazList.new.call['zones'].length
  end
end
