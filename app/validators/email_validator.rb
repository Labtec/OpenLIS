# frozen_string_literal: true

# Validates email format
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      record.errors[attribute] << (options[:message] || I18n.t(:invalid, scope: %i[errors messages]))
    end
  end
end
