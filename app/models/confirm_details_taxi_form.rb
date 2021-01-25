# frozen_string_literal: true

##
# This class is used to validate user data entered in confirm_details form.
class ConfirmDetailsTaxiForm < ConfirmDetailsBaseForm
  # Attribute used in confirm_details view
  attr_accessor :confirm_details

  # validates attributes to presence
  validates :confirm_details, presence: { message: I18n.t('confirm_details_form.confirm_details_missing') }
end
