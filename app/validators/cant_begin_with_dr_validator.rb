# frozen_string_literal: true

# Validates a Doctor's name
class CantBeginWithDrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:cant_begin_with_dr, scope: %i[errors messages])) if value && value.match?(/\ADra?(\s|\.).*\z/i)
  end
end
