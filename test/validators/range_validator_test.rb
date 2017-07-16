# frozen_string_literal: true

require 'test_helper'

class RangeValidatorTest < ActiveSupport::TestCase
  test 'validate result as a range' do
    r = results(:result)
    r.lab_test = lab_tests(:range)

    r.value = '1'
    assert r.invalid?, 'Result should be invalid (range)'
    assert r.errors[:value].any?,
           'A result with an invalid range value should contain an error'
    assert_equal ['must be N-N, <N or >N'], r.errors['value'],
                 'An invalid result error message is expected'

    r.value = '1-2'
    assert r.valid?, 'Value should be valid'

    r.value = '<1'
    assert r.valid?, 'Value should be valid'

    r.value = '>1'
    assert r.valid?, 'Value should be valid'
  end
end
