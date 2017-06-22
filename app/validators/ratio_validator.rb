# frozen_string_literal: true

# Validates ratio result format
class RatioValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/\A(\d+):(\d+)\z/)
      record.errors[attribute] << (options[:message] || I18n.t(:ratio, scope: %i[errors messages]))
    end
  end
end
