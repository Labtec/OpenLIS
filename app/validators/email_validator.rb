# frozen_string_literal: true

# Validates email format
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if URI::MailTo::EMAIL_REGEXP.match?(value)

    record.errors.add(attribute, options[:message] || I18n.t("errors.messages.invalid"))
  end
end
