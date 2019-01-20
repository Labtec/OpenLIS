# frozen_string_literal: true

require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  test 'presence of name' do
    unit = Unit.create(name: '')
    assert unit.errors.added?(:name, :blank)
  end

  test 'uniqueness of name' do
    unit = Unit.create(name: 'Units')
    assert unit.errors.added?(:name, :taken, value: 'Units')
  end

  test 'name contains extra spaces' do
    unit = Unit.create(name: '  Unit  ')
    assert_equal 'Unit', unit.name
  end

  test 'no extra spaces between names' do
    unit = Unit.create(name: 'International  Unit')
    assert_equal 'International Unit', unit.name
  end
end
