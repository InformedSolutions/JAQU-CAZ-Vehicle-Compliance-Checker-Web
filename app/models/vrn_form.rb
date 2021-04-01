# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicle_checkers/enter_details.html.haml+.
class VrnForm
  # Submitted vehicle registration number
  attr_reader :vrn
  # Selected country value, possible values: 'UK', 'Non-UK'
  attr_reader :country
  # Hash containing validation errors
  attr_reader :error_object

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +country+ - string, eg. 'UK'
  # * +error_object+ - empty hash, default error object
  def initialize(vrn, country)
    @vrn = vrn.gsub! /\t/, ''
    @country = country
    @error_object = {}
  end

  ##
  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    if uk?
      filled_vrn? && not_to_long? && not_to_short? && vrn_uk_format
    else
      filled_vrn?
    end
    filled_country?
    error_object.empty?
  end

  # Checks if vehicle is within the DVLA database but country of registration has been set to 'non-uk'
  def possible_fraud?
    return false if uk?
    vrn_uk_format && dvla_registered?
  end

  private

  # Checks if at least one +vrn+ was selected.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def filled_vrn?
    return true if vrn.present?

    vrn_error(I18n.t('vrn_form.vrn_missing'))
    false
  end

  # Checks if at least one +country+ was selected.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def filled_country?
    return true if country.present?

    @error_object[:country] = { message: I18n.t('vrn_form.country_missing'), link: '#country-error' }
    false
  end

  # Checks if +vrn+ format is valid.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def vrn_uk_format
    return true if FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn.gsub(/\s+/, '').gsub(/^0+/,'').upcase).present?
    end

    vrn_error(I18n.t('vrn_form.vrn_invalid'))
    false
  end

  # Checks if +vrn+ not to long.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def not_to_long?
    return true if vrn.gsub(/\s+/, '').gsub(/^0+/,'').length <= 7

    vrn_error(I18n.t('vrn_form.vrn_too_long'))
    false
  end

  # Checks if +vrn+ not to short.
  #
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def not_to_short?
    return true if vrn.gsub(/\s+/, '').gsub(/^0+/,'').length > 1

    vrn_error(I18n.t('vrn_form.vrn_too_short'))
    false
  end

  # Add error message to +error_object+.
  #
  # ==== Attributes
  #
  # * +msg+ - string, eg. 'Enter the registration number of the vehicle'

  # ==== Result
  #
  # Returns +error_object+ as hash.
  def vrn_error(msg)
    @error_object[:vrn] = { message: msg, link: '#vrn-error' }
  end

  # Check if VRN is DVLA registered
  def dvla_registered?
    ComplianceCheckerApi.vehicle_details(vrn)
    true
  rescue BaseApi::Error404Exception
    false
  end

  # Checks if selected country in UK. Returns boolean.
  def uk?
    country == 'UK'
  end

  # Regexps formats to validate +vrn+.
  #
  FORMAT_REGEXPS = [
    /^[A-Za-z]{1,2}[0-9]{1,4}$/,
    /^[A-Za-z]{3}[0-9]{1,3}$/,
    /^[1-9][0-9]{0,2}[A-Za-z]{3}$/,
    /^[1-9][0-9]{0,3}[A-Za-z]{1,2}$/,
    /^[A-Za-z]{3}[0-9]{1,3}[A-Za-z]$/,
    /^[A-Za-z][0-9]{1,3}[A-Za-z]{3}$/,
    /^[A-Za-z]{2}[0-9]{2}[A-Za-z]{3}$/,
    /^[A-Za-z]{3}[0-9]{4}$/,

    # The following regex is technically not valid, but is considered as valid
    # due to the requirement which forces users not to include leading zeros.
    /^[A-Z]{2,3}$/ # AA, AAA
  ].freeze
end
