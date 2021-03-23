# frozen_string_literal: true

##
# This class is used to display data in +app/views/static_pages/privacy_notice.html.haml+.
class CazLinkDisplayData
  # Attribute readers
  attr_reader :name, :privacy_policy_url, :display_from, :display_order

  ##
  # Creates an instance of a class
  #
  # ==== Attributes
  #
  # * +name+ - string, eg. 'Birmingham'
  # * +privacy_policy_url+ - string with URL, eg. 'http://example.com'
  # * +display_from+ - date, eg. '2021-03-15
  # * +display_order+ - integer, eg. 3
  #
  def initialize(name:, privacy_policy_url:, display_from:, display_order:)
    @name = name
    @privacy_policy_url = privacy_policy_url
    @display_from = display_from
    @display_order = display_order
  end

  ##
  # Instance method which receives a list of Clean Air Zones data and constructs a list
  # of the current class objects.
  #
  def self.from_list(caz_list)
    caz_list.map do |caz|
      new(name: caz['name'], privacy_policy_url: caz['privacyPolicyUrl'],
          display_from: Date.parse(caz['displayFrom']), display_order: caz['displayOrder'])
    end
  end
end
