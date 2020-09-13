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

  test 'flag of a lab test with multiple ranges including a nil max range' do
    @result.update(lab_test: lab_tests(:multiple_ranges_nil_max_range),
                   value: 10)
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

  test 'high flag of a range lab test with max range' do
    lab_test = lab_tests(:range)
    lab_test.update(reference_ranges: [reference_ranges(:less_than)])
    @result.update(lab_test: lab_test, value: '8-9')

    assert_nil @result.flag, 'highest value is less than 10'

    @result.update(value: '10-11')

    assert_equal 'H', @result.flag, 'highest value is greater than 10'
  end
end
