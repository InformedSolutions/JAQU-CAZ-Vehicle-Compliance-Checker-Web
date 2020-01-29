# frozen_string_literal: true

##
# This class is used to validate user data entered in confirm_details form.
class ConfirmDetailsForm < ConfirmDetailsBaseForm
  # Attribute used in confirm_details view
  attr_accessor :confirm_details, :confirm_taxi_or_phv

  # validates attributes to presence
  validates :confirm_details, presence: {
    message: I18n.t('confirm_details_form.confirm_details_missing')
  }

  # validates attributes to presence
  validates :confirm_taxi_or_phv, presence: {
    message: I18n.t('confirm_details_form.confirm_taxi_or_phv_missing')
  }
end
