# frozen_string_literal: true

class Caz
  def initialize(data)
    @caz_data = data.transform_keys { |key| key.underscore.to_sym }
  end

  def id
    caz_data[:clean_air_zone_id]
  end

  def name
    caz_data[:name]
  end

  def boundary_url
    caz_data[:boundary_url]
  end

  private

  attr_reader :caz_data
end
