# frozen_string_literal: true

# Validates cedula format
class CedulaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    cedula_parts = value.split('-')

    if (cedula_parts.size == 4 && !['NT', 'AV', 'PI'].include?(cedula_parts[1])) ||
      cedula_parts.size < 3 ||
      cedula_parts.size > 5 ||
      cedula_parts[1].size > 3 ||
      cedula_parts[2].size > 5
      record.errors.add(attribute, (options[:message] || I18n.t('errors.messages.invalid')))
    end
  end
end
