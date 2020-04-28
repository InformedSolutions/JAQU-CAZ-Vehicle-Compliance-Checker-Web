# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JaquCaz
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Load lib folder files
    config.eager_load_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # name of service
    config.x.service_name = 'Drive in a Clean Air Zone'

    feedback_url_default = 'https://www.surveymonkey.co.uk/r/2RNBKTV'
    config.x.feedback_url = (ENV['FEEDBACK_URL'].presence || feedback_url_default)

    contact_email_default = 'Useraccount.Query@defra.gov.uk'
    config.x.contact_email = (ENV['CONTACT_EMAIL'].presence || contact_email_default)

    config.x.contact_form_link = 'https://congestion:co2co2co2@contact-preprod.dvla.gov.uk/caz'

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'

    # Use the lowest log level to ensure availability of diagnostic information
    # when problems arise.
    config.log_level = :debug
  end
end
