# frozen_string_literal: true

##
# This class is used to validate user data entered in confirm_details form.
class ConfirmDetailsBaseForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Attribute used in confirm_details view
  attr_accessor :undetermined, :taxi_and_correct_type

  # Returns status for the vehicle type
  #
  # Returns a boolean.
  def undetermined?
    undetermined == 'true'
  end

  # Checks if user confirmation of vehicle details is equals 'yes'
  #
  # Returns a boolean.
  def confirmed?
    confirm_details == 'yes'
  end

  # Returns nil if vehicle type not allowed to be a taxi
  # Checks if user claims to be a taxi, but DVLA database returns he is not a taxi or phv.
  #
  # Returns a boolean.
  def user_confirms_to_be_taxi?
    return if taxi_and_correct_type == 'false'

    confirm_taxi_or_phv == 'true'
  end

  # Overrides default initializer for compliance with form_for method in confirm_details view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in confirm details view and should return nil when the object is not persisted.
  def to_key
    nil
  end
end