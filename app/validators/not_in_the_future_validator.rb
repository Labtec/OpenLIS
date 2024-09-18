# frozen_string_literal: true

# Validates a date or time is not in the future
class NotInTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value && value.in_time_zone > Time.current

    record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.cant_be_in_the_future")))
  end
end
