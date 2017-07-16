# frozen_string_literal: true

# Validates ratio result format
class RatioValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:ratio, scope: %i[errors messages])) unless value.match?(/\A(\d+):(\d+)\z/)
  end
end
