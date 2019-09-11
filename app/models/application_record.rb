# frozen_string_literal: true

##
# This is an abstract class.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
