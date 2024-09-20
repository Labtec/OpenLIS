# frozen_string_literal: true

# Validates range result format
class RangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.match?(/\A((<|>)|(\d+)(-))(\d+)\z/)

    record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.range")))
  end
end
