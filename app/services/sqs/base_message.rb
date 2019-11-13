# frozen_string_literal: true

##
# Service used to enqueueing messages on AWS SQS to be later caught by Notification Gateway microservice.
#
module Sqs
  class BaseMessage < BaseService
    ##
    # Initializer method. Used by class level +:call+ method
    #
    # ==== Attributes
    #
    # * +contact_form+ - a valid instance of {Contact Form model}[rdoc-ref:ContactForm]
    #
    def initialize(contact_form:)
      @reference = email_reference(contact_form)
      @subject = email_subject(contact_form)
      @email = contact_form.email
      @name = "#{contact_form.first_name} #{contact_form.last_name}"
      @body = contact_form.message
    end

    def call
      log_action("Sending SQS message with attributes: #{attributes}")
      id = send_message.message_id
      log_action("SQS message with id: #{id} nad reference: #{reference} was sent")
      id
    rescue Aws::SQS::Errors::ServiceError => e
      log_error(e)
      false
    end

    private

    attr_reader :subject, :email, :reference, :name, :body

    def send_message
      AWS_SQS.send_message(
        queue_url: ENV.fetch('NOTIFY_QUEUE_URL', ''),
        message_group_id: ENV.fetch('NOTIFY_GROUP_ID', 'VCCS_CONTACT_FORM'),
        message_body: attributes,
        message_attributes: {
          'contentType' => { string_value: 'application/json', data_type: 'String' }
        }
      )
    end

    def attributes
      {
        'templateId' => template_id,
        'emailAddress' => receiver_email,
        'personalisation' => message_details,
        'reference' => reference
      }.to_json
    end

    def email_reference(form)
      "#{form.last_name.upcase.delete(' ')}#{Time.current.strftime('%H%M%S')}"
    end

    def email_subject(form)
      "#{form.query_type} - #{reference}"
    end
  end
end
