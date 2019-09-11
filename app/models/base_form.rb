# frozen_string_literal: true

##
# This is an abstract class used as a base form for all form classes.
class BaseForm
  attr_reader :parameter, :message

  ##
  # Creates an instance of a form class.
  #
  # ==== Attributes
  #
  # * +parameter+ - abstract attribute can be any type, e.g. '["London", "York"]' or 'yes'
  # * +message+ - empty string, default error message
  def initialize(parameter)
    @parameter = parameter
    @message = ''
  end
end
