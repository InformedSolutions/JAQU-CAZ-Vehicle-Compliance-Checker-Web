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
    return true if parameter.present?

    @message = 'You must choose an answer'
    false
  end
end
