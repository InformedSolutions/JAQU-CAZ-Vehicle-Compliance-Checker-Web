# frozen_string_literal: true

class ConfirmationForm < BaseForm
  def valid?
    filled?
  end

  def confirmed?
    parameter == 'yes'
  end

  private

  def filled?
    @message = 'You must choose an answer'
    parameter.present?
  end
end
