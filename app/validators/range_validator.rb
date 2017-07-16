# frozen_string_literal: true

# Validates range result format
class RangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:range, scope: %i[errors messages])) unless value.match?(/\A((<|>)|(\d+)(-))(\d+)\z/)
  end
end
