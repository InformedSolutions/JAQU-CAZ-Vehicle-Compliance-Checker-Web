# frozen_string_literal: true

class CazForm < BaseForm
  def valid?
    chosen?
  end

  private

  def chosen?
    if !parameter.is_a?(Array) || parameter.reject(&:empty?).blank?
      @message = 'You must choose clean air zones'
      false
    else
      true
    end
  end
end
