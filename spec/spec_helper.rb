# frozen_string_literal: true

# Checks if no external calls are being performed during tests
require 'webmock/rspec'
# Checks code coverage
require 'simplecov'
# YARD is a Ruby Documentation tool.
require 'yard'

# Run scanner to check which files need to be documented
warn('Code documentation coverage:')
YARD::CLI::Stats.new.run('--list-undoc', '--compact', '--no-save')

SimpleCov.start 'rails' do
  # minimum coverage percentage expected
  minimum_coverage 100
  # ignore next folders and files
  add_filter %w[
    app/models/application_record.rb
    lib/
    config/
  ]
end
