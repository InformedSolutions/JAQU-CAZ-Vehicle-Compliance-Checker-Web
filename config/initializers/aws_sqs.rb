# frozen_string_literal: true

creds = if Rails.env.production?
          Aws::ECSCredentials.new(ip_address: '169.254.170.2')
        else
          Aws::Credentials.new(
            ENV['AWS_ACCESS_KEY_ID'],
            ENV['AWS_SECRET_ACCESS_KEY']
          )
        end

AWS_SQS = Aws::SQS::Client.new(
  region: ENV.fetch('AWS_REGION', 'eu-west-2'),
  credentials: creds
)
