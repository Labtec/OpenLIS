# frozen_string_literal: true

# Validates a Doctor's name
class CantBeginWithDrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value&.match?(/\ADra?(\s|\.).*\z/i)

    record.errors.add(attribute, options[:message] || I18n.t("errors.messages.cant_begin_with_dr"))
  end
end
