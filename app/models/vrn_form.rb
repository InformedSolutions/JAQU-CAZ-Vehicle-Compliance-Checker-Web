# frozen_string_literal: true

class VrnForm
  attr_reader :vrn, :country, :error_object

  def initialize(vrn, country)
    @vrn = vrn
    @country = country
  end

  def valid?
    filled_vrn? && not_to_long? && not_to_short? && valid_format? && filled_country?
  end

  private

  def filled_vrn?
    return true if vrn.present?

    @error_object = {
      message: I18n.t('vrn_form.vrn_missing'),
      field: 'vrn'
    }
    false
  end

  def filled_country?
    return true if country.present?

    @error_object = {
      message: I18n.t('vrn_form.country_missing'),
      field: 'country'
    }
    false
  end

  def valid_format?
    return true if FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn.gsub(/\s+/, '').upcase).present?
    end

    @error_object = {
      message: I18n.t('vrn_form.vrn_invalid'),
      field: 'vrn'
    }
    false
  end

  def not_to_long?
    return true if vrn.gsub(/\s+/, '').length <= 7

    @error_object = {
      message: I18n.t('vrn_form.vrn_too_long'),
      field: 'vrn'
    }
    false
  end

  def not_to_short?
    return true if vrn.gsub(/\s+/, '').length > 1

    @error_object = {
      message: I18n.t('vrn_form.vrn_too_short'),
      field: 'vrn'
    }
    false
  end

  FORMAT_REGEXPS = [
    /^[A-Z]{3}[0-9]{3}$/, # AAA999
    /^[A-Z][0-9]{3}[A-Z]{3}$/, # A999AAA
    /^[A-Z]{3}[0-9]{3}[A-Z]$/, # AAA999A
    /^[A-Z]{3}[0-9]{4}$/, # AAA9999
    /^[A-Z]{2}[0-9]{2}[A-Z]{3}$/, # AA99AAA
    /^[0-9]{4}[A-Z]{3}$/, # 9999AAA
    /^[A-Z][0-9]$/, # A9
    /^[0-9][A-Z]$/, # 9A
    /^[A-Z]{2}[0-9]$/, # AA9
    /^[A-Z][0-9]{2}$/, # A99
    /^[0-9][A-Z]{2}$/, # 9AA
    /^[0-9]{2}[A-Z]$/, # 99A
    /^[A-Z]{3}[0-9]$/, # AAA9
    /^[A-Z][0-9]{3}$/, # A999
    /^[A-Z]{2}[0-9]{2}$/, # AA99
    /^[0-9][A-Z]{3}$/, # 9AAA
    /^[0-9]{2}[A-Z]{2}$/, # 99AA
    /^[0-9]{3}[A-Z]$/, # 999A
    /^[A-Z][0-9][A-Z]{3}$/, # A9AAA
    /^[A-Z]{3}[0-9][A-Z]$/, # AAA9A
    /^[A-Z]{3}[0-9]{2}$/, # AAA99
    /^[A-Z]{2}[0-9]{3}$/, # AA999
    /^[0-9]{2}[A-Z]{3}$/, # 99AAA
    /^[0-9]{3}[A-Z]{2}$/, # 999AA
    /^[0-9]{4}[A-Z]$/, # 9999A
    /^[A-Z][0-9]{4}$/, # A9999
    /^[A-Z][0-9]{2}[A-Z]{3}$/, # A99AAA
    /^[A-Z]{3}[0-9]{2}[A-Z]$/, # AAA99A
    /^[0-9]{3}[A-Z]{3}$/, # 999AAA
    /^[A-Z]{2}[0-9]{4}$/, # AA9999
    /^[0-9]{4}[A-Z]{2}$/ # 9999AA
  ].freeze
end
