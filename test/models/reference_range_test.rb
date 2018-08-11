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
end
