# frozen_string_literal: true

class ComplianceDetails
  def initialize(details)
    @compliance_data = details.deep_transform_keys { |key| key.underscore.to_sym }
  end

  def zone_name
    compliance_data[:name]
  end

  def charged?
    compliance_data[:charge].to_f > 0.0
  end

  def charge
    "£#{format('%.2f', compliance_data[:charge].to_f)}"
  end

  def main_info_url
    compliance_data[:information_urls][:main_info]
  end

  def emissions_standards_url
    compliance_data[:information_urls][:emissions_standards]
  end

  def pricing_url
    compliance_data[:information_urls][:pricing]
  end

  def hours_of_operation_url
    compliance_data[:information_urls][:hours_of_operation]
  end

  def exemption_or_discount_url
    compliance_data[:information_urls][:exemption_or_discount]
  end

  def pay_caz_url
    compliance_data[:information_urls][:pay_caz]
  end

  def become_compliant_url
    compliance_data[:information_urls][:become_compliant]
  end

  def financial_assistance_url
    compliance_data[:information_urls][:financial_assistance]
  end

  def boundary_url
    compliance_data[:information_urls][:boundary]
  end

  private

  attr_reader :compliance_data
end
