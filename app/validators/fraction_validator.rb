# Validates fraction result format
class FractionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(\d+)\/(\d+)\z/
      record.errors[attribute] << (options[:message] || I18n.t(:fraction, scope: [:errors, :messages]))
    end
  end
end
