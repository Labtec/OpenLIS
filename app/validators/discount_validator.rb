# frozen_string_literal: true

# Validates discounts
class DiscountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present? && record.list_price.present?

    if record.discount_percentage? && !value.in?(0..100)
      record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.must_be_between_0_and_100")))
    end
    if record.discount_currency? && value > record.list_price
      record.errors.add(attribute, (options[:message] || I18n.t("errors.messages.must_be_less_than_or_equal_to_list_price")))
    end
  end
end
