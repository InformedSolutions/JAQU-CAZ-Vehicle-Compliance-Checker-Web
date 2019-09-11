# frozen_string_literal: true

##
# This class is used to display data in +app/views/air_zones/caz_selection.html.haml+.
class Caz
  ##
  # Creates an instance of a form class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +data+ - hash
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +zones+ - array, eg. '["39e54ed8-3ed2-441d-be3f-38fc9b70c8d3"]'
  # * +name+ - string, eg. 'Birmingham'
  # * +clean_air_zone_id+ - UUID
  # * +boundary_url+ - string, eg. 'www.example.com'
  def initialize(data)
    @caz_data = data.transform_keys { |key| key.underscore.to_sym }
  end

  # Returns a UUID.
  def id
    caz_data[:clean_air_zone_id]
  end

  # Returns a string, eg. 'Birmingham'.
  def name
    caz_data[:name]
  end

  # Returns a string, eg. 'www.example.com'.
  def boundary_url
    caz_data[:boundary_url]
  end

  private

  attr_reader :caz_data
end
