# frozen_string_literal: true

require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  test 'presence of expression' do
    unit = Unit.create(expression: '')
    assert unit.errors.added?(:expression, :blank)
  end

  test 'uniqueness of expression' do
    unit = Unit.create(expression: 'Units')
    assert unit.errors.added?(:expression, :taken, value: 'Units')
  end

  test 'numericality of conversion factor' do
    unit = units(:units)
    unit.update(si: 'Units', conversion_factor: 'invalid')
    assert unit.errors.added?(:conversion_factor, :not_a_number, value: 'invalid')
  end

  test 'expression contains extra spaces' do
    unit = Unit.create(expression: '  Unit  ')
    assert_equal 'Unit', unit.expression
  end

  test 'no extra spaces between expressions' do
    unit = Unit.create(expression: 'International  Unit')
    assert_equal 'International Unit', unit.expression
  end

  test 'absence of expression except when UCUM present' do
    unit = Unit.create(expression: '', ucum: '{ratio}')
    assert unit.valid?
  end

  test 'presence of conversion_factor when SI present' do
    unit = units(:units)
    unit.update(si: 'Units')
    assert_not unit.valid?
  end

  test 'absence of conversion_factor when no SI' do
    unit = units(:units)
    unit.update(conversion_factor: 1)
    assert_not unit.valid?
  end
end
