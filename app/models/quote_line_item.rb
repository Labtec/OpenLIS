# frozen_string_literal: true

class QuoteLineItem < ApplicationRecord
  RETIREE_PERCENTAGE_DISCOUNT = 20

  enum :discount_unit, { percentage: 0, currency: 1 }, prefix: :discount, default: :percentage
  include DiscountUnitEnumValidation

  belongs_to :quote
  belongs_to :item, polymorphic: true

  validates :discount_value, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_value, discount: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  default_scope -> { order("quote_line_items.id ASC") }

  delegate :fasting_status_duration, to: :item, allow_nil: true
  delegate :name, to: :item
  delegate :procedure, to: :item, allow_nil: true
  delegate :patient_preparation, to: :item, allow_nil: true
  delegate :price_list, to: :quote

  before_create :apply_retiree_discount

  def discount
    if discount_value.present? && discount_unit.present?
      return discount_value if discount_currency?
      return list_price * discount_value / 100 if discount_percentage?
    end

    0
  end

  def list_price
    item.prices.from_price_list(price_list).take&.amount || 0
  end

  def subtotal
    list_price * quantity.to_i
  end

  def total_discount
    discount * quantity.to_i
  end

  def total_price
    subtotal - total_discount
  end

  private

  def apply_retiree_discount
    return unless quote.patient_retiree?

    self.discount_value = RETIREE_PERCENTAGE_DISCOUNT
    self.discount_unit = 0 # discount_units[:percentage]
  end
end
