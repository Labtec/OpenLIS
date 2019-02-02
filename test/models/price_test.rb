# frozen_string_literal: true

require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  test 'presence of price list' do
    price = Price.create(price_list: nil)
    assert price.errors.added?(:price_list, :blank)
  end

  test 'presence of priceable' do
    price = Price.create(priceable: nil)
    assert price.errors.added?(:priceable, :blank)
  end

  test 'presence of priceable type' do
    price = Price.create(priceable_type: '')
    assert price.errors.added?(:priceable_type, :blank)
  end

  test 'uniqueness of priceable scoped to price list and priceable type' do
    price = Price.create(priceable_id: 1)
    assert_not price.errors.added?(:priceable_id, :taken, value: 1)

    price = Price.create(priceable_id: 1,
                         price_list: price_lists(:price_list),
                         priceable_type: 'LabTest')
    assert price.errors.added?(:priceable_id, :taken, value: 1)
  end

  test 'numericality of amount greater than or equal to 0.00' do
    price = Price.create(amount: 'x')
    assert price.errors.added?(:amount, :not_a_number, value: 'x')

    price = Price.create(amount: -1)
    assert price.errors.added?(:amount, :greater_than_or_equal_to,
                               count: 0.00, value: -1)
  end
end
