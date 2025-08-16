# frozen_string_literal: true

# Validates a value is within absolute range
class OutOfAbsoluteRangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.absolute_interval.present? && value.present?

    record.errors.add(attribute, options[:message] || I18n.t("errors.messages.is_out_of_absolute_range")) unless record.absolute_interval.range.cover?(value.to_d)
  end
end
