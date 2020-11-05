# frozen_string_literal: true

# Validates fraction result format
class FractionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(%r{\A(\d+)/(\d+)\z})
      record.errors.add(attribute, (options[:message] || I18n.t(:fraction, scope: %i[errors messages])))
    end
  end
end
