# frozen_string_literal: true

module Sqs
  class UserMessage < BaseMessage
    private

    def template_id
      ENV.fetch('NOTIFY_COPY_TEMPLATE_ID', 'e9c1f384-ad75-471b-96aa-717f406a5806')
    end

    def receiver_email
      email
    end

    def message_details
      { subject: subject }.to_json
    end
  end
end
