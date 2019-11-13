# frozen_string_literal: true

module Sqs
  class JaquMessage < BaseMessage
    private

    def template_id
      ENV.fetch('NOTIFY_TEMPLATE_ID', '7337cc7a-6aee-4558-850f-fd5ca50bd1b3')
    end

    def receiver_email
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
end
