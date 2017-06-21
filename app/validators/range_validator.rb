# frozen_string_literal: true

# Validates range result format
class RangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A((<|>)|(\d+)(-))(\d+)\z/
      record.errors[attribute] << (options[:message] || I18n.t(:range, scope: [:errors, :messages]))
    end
  end
end
