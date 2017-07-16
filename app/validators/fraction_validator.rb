# frozen_string_literal: true

# Validates fraction result format
class FractionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:fraction, scope: %i[errors messages])) unless value.match?(%r{\A(\d+)/(\d+)\z})
  end
end
