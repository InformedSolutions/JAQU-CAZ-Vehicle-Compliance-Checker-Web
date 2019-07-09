# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @caz_count = ComplianceCheckerApi::CazList.new.call['zones'].size
  end
end
