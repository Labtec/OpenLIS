# frozen_string_literal: true

# Validates LOINC format
class LOINCValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    loinc = value.split('-')
    check_digit = loinc[1].to_i if loinc[1].present?
    record.errors[attribute] << (options[:message] || I18n.t(:invalid, scope: %i[errors messages])) unless Luhn.checksum(loinc[0]) == check_digit
  end
end
