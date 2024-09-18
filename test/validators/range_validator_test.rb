# frozen_string_literal: true

require "test_helper"

class RangeValidatorTest < ActiveSupport::TestCase
  test "validate value as a range" do
    r = observations(:observation)
    r.lab_test = lab_tests(:range)

    r.value = "1"
    assert r.invalid?, "Value should be invalid (range)"
    assert r.errors[:value].any?,
           "An observation with an invalid range value should contain an error"
    assert_equal [ "must be N-N, <N or >N" ], r.errors["value"],
                 "An invalid observation error message is expected"

    r.value = "1-2"
    assert r.valid?, "Value should be valid"

    r.value = "<1"
    assert r.valid?, "Value should be valid"

    r.value = ">1"
    assert r.valid?, "Value should be valid"
  end
end
