# frozen_string_literal: true

creds = if ENV['AWS_ACCESS_KEY_ID']
          Aws::Credentials.new(
            ENV['AWS_ACCESS_KEY_ID'],
            ENV['AWS_SECRET_ACCESS_KEY']
          )
        else
          Aws::ECSCredentials.new({ ip_address: '169.254.170.2' })
        end

AWS_SQS = Aws::SQS::Client.new(
  region: ENV.fetch('AWS_REGION', 'eu-west-2'),
  credentials: creds
)
