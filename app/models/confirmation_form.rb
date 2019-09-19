# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicle_checkers/confirm_details.html.haml+.
class ConfirmationForm
  # form confirmation from the query params, values: 'yes', 'no', nil
  attr_reader :confirmation
  # status for the vehicle type from the query params, values: 'true', 'false'
  attr_reader :undetermined
  # error message, string
  attr_reader :message
  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +confirmation+ - string, eg. 'yes'
  # * +undetermined+ - string, eg. 'true'
  # * +message+ - empty string, default error message
  def initialize(confirmation, undetermined)
    @confirmation = confirmation
    @undetermined = undetermined
    @message = nil
  end

  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    filled?
  end

  # Checks if +confirmation+ equality to 'yes' and +undetermined+ equality to 'false'.
  #
  # Returns a boolean.
  def confirmed_and_determined?
    confirmation == 'yes' && undetermined == 'false'
  end

  # Checks if +confirmation+ equality to 'yes' and +undetermined+ equality to 'true'.
  #
  # Returns a boolean.
  def confirmed_and_undetermined?
    confirmation == 'yes' && undetermined == 'true'
  end

  private

  # Checks if at least one answer was selected.
  # If not, add error message to +message+.
  #
  # Returns a boolean.
  def filled?
    return true if confirmation.present?

    @message = 'You must choose an answer'
    false
  end
end
