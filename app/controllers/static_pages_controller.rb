# frozen_string_literal: true

##
# Controller class for the static pages
#
class StaticPagesController < ApplicationController
  ##
  # Renders the accessibility statement page
  #
  # ==== Path
  #    GET /accessibility_statement
  #
  def accessibility_statement
    # renders static page
  end

  ##
  # Renders the static cookies page
  #
  # ==== Path
  #    GET /cookies
  #
  def cookies
    # renders static page
  end

  ##
  # Renders the static privacy notice page
  #
  # ==== Path
  #    GET /privacy_notice
  #
  def privacy_notice
    links_data = CazLinkDisplayData.from_list(ComplianceCheckerApi.clean_air_zones)
    @caz_link_display_data = links_data.reject { |caz_link_data| caz_link_data.display_from.future? }
  end
end
