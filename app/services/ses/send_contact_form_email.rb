# frozen_string_literal: true

##
# Module used to send emails via AWS SES
#
module Ses
  ##
  # Sends an email to the admin with question about problem.
  #
  class SendContactFormEmail < BaseService
    ##
    # Initializer method for the class. Used by class level method {call}[rdoc-ref:BaseService::call]
    #
    # ==== Attributes
    #
    # * +params+ - hash with data about the contact form
    #   * +user_email+ - string, user email address
    #   * +full_name+ - string, full name of user
    #   * +query_type+ - string, type of query
    #   * +message+ - string, user message typed in form
    def initialize(params:)
      @user_email = params['email']
      @full_name = "#{params['first_name']} #{params['last_name']}"
      @query_type = params['query_type']
      @message = params['message']
    end

    ##
    # Executing method for the class. Used by class level method {call}[rdoc-ref:BaseService::call]
    #
    # Returns true if sending email was successful, false if not. Rescues all the errors.
    #
    def call
      send_email
      true
    rescue StandardError => e
      log_error(e)
      false
    end

    private

    # Calls the mailer class
    def send_email
      log_action("Sending :contact_form by user: #{user_email}")
      ContactFormMailer.send_email(user_email, full_name, query_type, message).deliver
      log_action('Email sent successfully')
    end

    # Variables used internally by the service
    attr_reader :user_email, :full_name, :query_type, :message
  end
end
