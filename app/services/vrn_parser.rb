# frozen_string_literal: true

# https://eaflood.atlassian.net/browse/VCCS-131
# Class parses VRN according to included in the task business rules
# See specs for examples

class VrnParser < BaseService
  attr_reader :vrn, :result, :group

  def initialize(vrn:)
    @vrn = vrn.upcase
    @result = ''
    @group = []
  end

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

  def prepend_to_result
    @result += if result.empty? && numeric?(group.last)
                 prepend_zeroes
               else
                 prepend_dashes
               end
  end

  def finalize_result
    @result += if result.length > 5
                 group.join
               else
                 prepend_dashes
               end
    result[-7..-1] || result
  end

  def prepend_dashes
    group.join.rjust(3, '-')
  end

  def prepend_zeroes
    group.join.rjust(4, '0')
  end

  def same_type(char)
    (numeric?(group.last) && numeric?(char)) || (letter?(group.last) && letter?(char))
  end

  def numeric?(char)
    !(char =~ /[0-9]/).nil?
  end

  def letter?(char)
    !(char =~ /[A-Z]/).nil?
  end
end
