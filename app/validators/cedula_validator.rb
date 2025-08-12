# frozen_string_literal: true

class CedulaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Cedula::REGEXP.match?(value)

    record.errors.add(attribute, options[:message] || I18n.t("errors.messages.invalid"))
  end
end
