# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicle_checkers/confirm_details.html.haml+.
class ConfirmationForm < BaseForm
  ##
  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    filled?
  end

  # Checks if parameter equality to 'yes'.
  #
  # Returns a boolean.
  def confirmed?
    parameter == 'yes'
  end

  private

  # Checks if at least one answer was selected.
  # If not, add error message to +message+.
  #
  # Returns a boolean.
  def filled?
    return true if parameter.present?

    @message = 'You must choose an answer'
    false
  end
end
