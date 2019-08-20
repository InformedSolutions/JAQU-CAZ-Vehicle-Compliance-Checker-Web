# frozen_string_literal: true

module ParsedResponse
  def json_response
    JSON.parse(response.body)
  end

  def xml_response
    Hash.from_xml(response.body)
  end
end
