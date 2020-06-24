# frozen_string_literal: true

module Helpers
  # Reads provided file from +spec/fixtures/files+ directory
  def read_response(filename)
    JSON.parse(File.read("spec/fixtures/files/#{filename}"))
  end
end

World(Helpers)
