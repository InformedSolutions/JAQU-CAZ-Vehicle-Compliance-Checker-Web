# frozen_string_literal: true

class InvalidRequestException < ApplicationException
  def initialize
    message = 'Invalid request'
    super(message)
  end
end
