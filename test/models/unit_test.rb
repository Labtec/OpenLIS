require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  test 'name contains extra spaces' do
    unit = Unit.create(name: '  Unit  ')
    assert_equal 'Unit', unit.name
  end

  test 'no extra spaces between names' do
    unit = Unit.create(name: 'International  Unit')
    assert_equal 'International Unit', unit.name
  end
end
