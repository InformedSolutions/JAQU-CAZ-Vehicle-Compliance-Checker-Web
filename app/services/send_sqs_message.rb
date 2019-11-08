# frozen_string_literal: true

##
# Service used to enqueueing messages on AWS SQS to be later caught by Notification Gateway microservice.
#
class SendSqsMessage < BaseService
  ##
  # Initializer method. Used by class level +:call+ method
  #
  # ==== Attributes
  #
  # * +contact_form+ - a valid instance of {Contact Form model}[rdoc-ref:ContactForm]
  #
  def initialize(contact_form:)
    @subject = contact_form.query_type
    @email = contact_form.email
    @reference_number = SecureRandom.uuid
    @name = "#{contact_form.first_name} #{contact_form.last_name}"
    @body = contact_form.message
  end

  def call
    log_action("Sending SQS message with attributes: #{attributes}")
    id = send_message.message_id
    log_action("SQS message with id: #{id} nad reference: #{reference_number} was sent")
    id
  rescue Aws::SQS::Errors::ServiceError => e
    log_error(e)
    false
  end

  private

  attr_reader :subject, :email, :reference_number, :name, :body

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
      'emailAddress' => contact_email,
      'personalisation' => message_details,
      'reference' => reference_number
    }.to_json
  end

  def template_id
    ENV.fetch('NOTIFY_TEMPLATE_ID', '7337cc7a-6aee-4558-850f-fd5ca50bd1b3')
  end

  def contact_email
    Rails.configuration.x.contact_email
  end

  def message_details
    {
      name: name,
      email: email,
      body: body,
      subject: subject
    }.to_json
  end
end
