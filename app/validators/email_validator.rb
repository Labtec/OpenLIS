# frozen_string_literal: true

# Validates email format
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless URI::MailTo::EMAIL_REGEXP.match?(value)
      record.errors.add(attribute, (options[:message] || I18n.t(:invalid, scope: %i[errors messages])))
    end
  end
end
