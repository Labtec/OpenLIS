# Validates ratio result format
class RatioValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(\d+):(\d+)\z/
      record.errors[attribute] << (options[:message] || I18n.t(:ratio, scope: [:errors, :messages]))
    end
  end
end
