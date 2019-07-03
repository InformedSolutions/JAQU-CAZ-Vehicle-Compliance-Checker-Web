# frozen_string_literal: true

class CazForm < BaseForm
  def valid?
    choosed?
  end

  private

  def choosed?
    if parameter.blank?
      @message = 'You must choose clean air zones'
      false
    else
      true
    end
  end
end
