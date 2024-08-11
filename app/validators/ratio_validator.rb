# frozen_string_literal: true

# Validates ratio result format
class RatioValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/\A(\d+):(\d+)\z/)
      record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.ratio")))
    end
  end
end
