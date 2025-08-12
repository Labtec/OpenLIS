# frozen_string_literal: true

# Validates fraction result format
class FractionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.match?(%r{\A(\d+)/(\d+)\z})

    record.errors.add(attribute, options[:message] || I18n.t("errors.messages.fraction"))
  end
end
