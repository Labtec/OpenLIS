# frozen_string_literal: true

# Validates a patient is not too old
class NotTooOldValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, (options[:message] || I18n.t(:cant_be_that_old, scope: %i[errors messages]))) if value && value.in_time_zone < 300.years.ago
  end
end
