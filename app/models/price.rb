# frozen_string_literal: true

# Consider caching this model
class Price < ApplicationRecord
  belongs_to :price_list
  belongs_to :priceable, polymorphic: true

  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }
  validates :priceable_id, uniqueness: { scope: %i[price_list_id priceable_type] }
  validates :priceable_type, presence: true

  scope :from_price_list, ->(price_list) { where(price_list:) }

  delegate :status, to: :priceable

  def self.active
    active_prices = []
    all.each do |price|
      active_prices << price if price.status == "active"
    end
    active_prices
  end
end
