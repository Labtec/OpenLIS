# frozen_string_literal: true

# Validates a date or time is not in the future
class NotInTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:cant_be_in_the_future, scope: %i[errors messages])) if value && value.in_time_zone > Time.current
  end
end
