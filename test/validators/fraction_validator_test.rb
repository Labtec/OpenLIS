# frozen_string_literal: true

require "test_helper"

class FractionValidatorTest < ActiveSupport::TestCase
  test "validate value as a fraction" do
    r = observations(:observation)
    r.lab_test = lab_tests(:fraction)

    r.value = "1"
    assert r.invalid?, "Value should be invalid (fraction)"
    assert r.errors[:value].any?,
           "An observation with an invalid fraction value should contain an error"
    assert_equal [ "must be N/N" ], r.errors["value"],
                 "An invalid observation error message is expected"

    r.value = "1/2"
    assert r.valid?, "Value should be valid"
  end
end
