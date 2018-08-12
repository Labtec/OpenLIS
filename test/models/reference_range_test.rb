# frozen_string_literal: true

require 'test_helper'

class ReferenceRangeTest < ActiveSupport::TestCase
  setup do
    @result = results(:result)
  end

  test 'flag of a lab test with multiple ranges including a nil min range' do
    @result.update(lab_test: lab_tests(:multiple_ranges_nil_min_range),
                   value: 1)
    assert_nil @result.flag
  end

  test 'flag of a lab test with a nil max range' do
    @result.update(lab_test: lab_tests(:reference_range_greater_than))

    @result.update(value: 1)
    assert_equal 'L', @result.flag

    @result.update(value: 11)
    assert_nil @result.flag
  end

  test 'flag of a lab test with min and max ranges' do
    @result.update(lab_test: lab_tests(:reference_range))

    @result.update(value: 1)
    assert_equal 'L', @result.flag

    @result.update(value: 500)
    assert_nil @result.flag

    @result.update(value: 5_000)
    assert_equal 'H', @result.flag

    @result.update(value: '1,000')
    assert_nil @result.flag, 'value contains a comma'
  end
end
