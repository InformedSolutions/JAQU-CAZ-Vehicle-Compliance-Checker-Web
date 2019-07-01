# frozen_string_literal: true

class VrnForm < BaseForm
  def valid?
    filled? && valid_format? && not_to_long?
  end

  private

  def filled?
    @message = 'You must enter your registration number'
    parameter.present?
  end

  def valid_format?
    @message = 'You must enter your registration number in valid format'
    parameter.match('^[a-zA-Z0-9\s]+$').present?
  end

  def not_to_long?
    @message = 'Your registration number is too long'
    parameter.gsub(/\s+/, '').length <= 7
  end
end
