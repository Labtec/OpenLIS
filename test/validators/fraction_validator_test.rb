# frozen_string_literal: true

require 'test_helper'

class FractionValidatorTest < ActiveSupport::TestCase
  test 'validate result as a fraction' do
    r = results(:result)
    r.lab_test = lab_tests(:fraction)

    r.value = '1'
    assert r.invalid?, 'Result should be invalid (fraction)'
    assert r.errors[:value].any?,
           'A result with an invalid fraction value should contain an error'
    assert_equal ['must be N/N'], r.errors['value'],
                 'An invalid result error message is expected'

    r.value = '1/2'
    assert r.valid?, 'Value should be valid'
  end
end
