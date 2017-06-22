# frozen_string_literal: true

require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  subject do
    Price.new(amount: 9.99,
              price_list_id: 1,
              priceable_id: 1,
              priceable_type: 'LabTest')
  end

  should validate_numericality_of(:amount)
    .is_greater_than_or_equal_to(0.00)
  should validate_presence_of(:price_list_id)
  should validate_presence_of(:priceable_id)
  should validate_uniqueness_of(:priceable_id)
    .scoped_to(:price_list_id)
  should validate_presence_of(:priceable_type)
end
