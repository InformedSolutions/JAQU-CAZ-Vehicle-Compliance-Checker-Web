# frozen_string_literal: true

if ENV['COMPLIANCE_CHECKER_API_URL'].blank?
  Rails.logger.debug('COMPLIANCE_CHECKER_API_URL environment variable not set')
end
