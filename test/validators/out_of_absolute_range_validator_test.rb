# frozen_string_literal: true

require "test_helper"

class OutOfAbsoluteRangeValidatorTest < ActiveSupport::TestCase
  test "value is within absolute range" do
    observation = observations(:observation)
    QualifiedInterval.create(category: "absolute", range_low_value: 0, range_high_value: 10, lab_test: observation.lab_test)

    observation.value = 100

    assert observation.invalid?, "Value should be invalid"
    assert observation.errors[:value].any?,
           "An observation with a value outside the absolute range should contain an error"
    assert_equal [ "is outside absolute range" ], observation.errors["value"],
                 "An invalid error message is expected"

    observation.value = 5
    assert observation.valid?, "Value should be valid"
  end
end
