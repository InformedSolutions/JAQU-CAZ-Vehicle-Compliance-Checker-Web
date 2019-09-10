# frozen_string_literal: true

##
# This class parses VRN according to included in the
# {task}[https://eaflood.atlassian.net/browse/VCCS-131] business rules.
#
# ==== Examples
#
# * A9 -> \--A\--9
# * 9AA -> 0009-AA
# See specs or business rules for more examples.
#
# ==== Usage
#
# The service should be called using {BaseService class level method "call"}[rdoc-ref:BaseService::call]
#
#    VrnParser.call(vrn: 'CU1234')
class VrnParser < BaseService
  ##
  # The initialization method for the service
  # ==== Attributes
  #
  # * +vrn+ - an unparsed vehicle registration number submitted by the user
  def initialize(vrn:)
    @vrn = vrn.upcase
    @result = ''
    @group = []
  end

  ##
  # The caller method for the service.
  # It invokes parsing on the submitted VRN.
  #
  # It returns parsed VRN.
  # ==== Parsing logic
  #
  # VRN is split into characters and get processed one by one.
  #
  # In the first step, characters are put into a temporary group if the group is empty or
  # the character is the same type (number or letter) as the previous one.
  # If not, the group is summarized by prepending dashes or zeros and pushed into the result.
  # The new group is initialized with the current character.
  #
  # In the next step, additional dashes are prepended to the last group,
  # and the group is merged with the result.
  # Then, up to 7 characters are taken as a final result.
  def call
    return vrn if vrn.length > 6

    vrn.split('').each do |char|
      if group.empty? || same_type(char)
        group.push(char)
      else
        prepend_to_result
        @group = [char]
      end
    end
    finalize_result
  end

  private

  # Attributes used internally to save values
  attr_reader :vrn, :result, :group

  # Prepends dashes or zeros to the group
  # Zeroes are prepended only to the numeric group if it is the first one.
  def prepend_to_result
    @result += if result.empty? && numeric?(group.last)
                 prepend_zeroes
               else
                 prepend_dashes
               end
  end

  # Merges last group to the result and appends dashes if needed.
  # It returns up to 7 characters.
  def finalize_result
    @result += if result.length > 5
                 group.join
               else
                 prepend_dashes
               end
    result[-7..-1] || result
  end

  # prepends up to 3 dashes to the group
  def prepend_dashes
    group.join.rjust(3, '-')
  end

  # prepends up to 4 zeros to the group
  def prepend_zeroes
    group.join.rjust(4, '0')
  end

  # checks if last member of the group is tha same type as given character
  def same_type(char)
    (numeric?(group.last) && numeric?(char)) || (letter?(group.last) && letter?(char))
  end

  # checks if given character is a number
  def numeric?(char)
    !(char =~ /[0-9]/).nil?
  end

  # checks if given character is a letter
  def letter?(char)
    !(char =~ /[A-Z]/).nil?
  end
end
