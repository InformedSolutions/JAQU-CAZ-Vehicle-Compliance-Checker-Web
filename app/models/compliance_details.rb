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
    url(:main_info)
  end

  def emissions_standards_url
    url(:emissions_standards)
  end

  def pricing_url
    url(:pricing)
  end

  def hours_of_operation_url
    url(:hours_of_operation)
  end

  def exemption_or_discount_url
    url(:exemption_or_discount)
  end

  def pay_caz_url
    url(:pay_caz)
  end

  def become_compliant_url
    url(:become_compliant)
  end

  def financial_assistance_url
    url(:financial_assistance)
  end

  def boundary_url
    url(:boundary)
  end

  def html_id
    zone_name.delete(' ').underscore
  end

  private

  def url(name)
    compliance_data.dig(:information_urls, name)
  end

  attr_reader :compliance_data
end
