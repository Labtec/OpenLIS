# frozen_string_literal: true

class CedulaValidator < ActiveModel::EachValidator
  CEDULA_REGEXP = /\A(([2-9]|1[0-3]?)(?:AV|PI|-(NT))?|E|N|PE)-(\d{1,4})-(\d{1,6})\z/

  def validate_each(record, attribute, value)
    return if CEDULA_REGEXP.match?(value)

    record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.invalid")))
  end
end
