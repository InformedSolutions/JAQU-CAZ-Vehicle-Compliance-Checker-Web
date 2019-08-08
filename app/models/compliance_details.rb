# frozen_string_literal: true

class ComplianceDetails
  def initialize(details)
    @compliance_data = details.transform_keys { |key| key.underscore.to_sym }
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
    compliance_data[:main_info_url]
  end

  def emissions_standards_url
    compliance_data[:emissions_standards_url]
  end

  def pricing_url
    compliance_data[:pricing_url]
  end

  def hours_of_operation_url
    compliance_data[:hours_of_operation_url]
  end

  def exemption_or_discount_url
    compliance_data[:exemption_or_discount_url]
  end

  def pay_caz_url
    compliance_data[:pay_caz_url]
  end

  def become_compliant_url
    compliance_data[:become_compliant_url]
  end

  def financial_assistance_url
    compliance_data[:financial_assistance_url]
  end

  def boundary_url
    compliance_data[:boundary_url]
  end

  private

  attr_reader :compliance_data
end
