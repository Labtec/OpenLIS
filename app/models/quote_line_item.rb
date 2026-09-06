# frozen_string_literal: true

class QuoteLineItem < ApplicationRecord
  # https://www.gacetaoficial.gob.pa/storage/gacetas/2009/06/26314_A/18494.pdf
  # 6. Descuento de 15% de la cuenta total por servicios de hospitales y clínicas privadas.
  # 6. Descuento de 15% de la cuenta total por servlclOs de hospitales, clínicas,
  # laboratorios privados, centros de imagenología y otros establecimientos que
  # brinden servicios de salud.
  RETIREE_PERCENTAGE_DISCOUNT = 15

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
  delegate :procedure_quantity, to: :item, allow_nil: true
  delegate :associated_procedures, to: :item, allow_nil: true
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
