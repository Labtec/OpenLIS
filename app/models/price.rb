# frozen_string_literal: true

class Price < ApplicationRecord
  # Consider caching this model

  belongs_to :price_list
  belongs_to :priceable, polymorphic: true

  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }
  validates :priceable_id, uniqueness: { scope: %i[price_list_id priceable_type] }
  validates :priceable_type, presence: true
end
