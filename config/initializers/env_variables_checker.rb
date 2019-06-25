# frozen_string_literal: true

if ENV['COMPLIANCE_CHECKER_API_URL'].blank?
  raise('You need to set COMPLIANCE_CHECKER_API_URL variable in .env file.')
end
