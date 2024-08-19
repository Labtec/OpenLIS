# frozen_string_literal: true

require "test_helper"

class ObservationTest < ActiveSupport::TestCase
  setup do
    @observation = observations(:observation)
  end

  test "text value contains extra spaces" do
    @observation.update(lab_test: lab_tests(:text),
                        value: "  Observation Value  ")
    assert_equal "Observation Value", @observation.value
  end

  test "no extra spaces between text value words" do
    @observation.update(lab_test: lab_tests(:text),
                        value: "Observation  Value")
    assert_equal "Observation Value", @observation.value
  end

  test "value is not in proper decimal notation" do
    crtsa = observations(:crtsa)
    egfrcr = observations(:egfrcr)
    crtsa.update(value: "0,9")
    assert_equal 7, egfrcr.derived_value

    crtsa.update(value: "0,s")
    assert_equal Float::INFINITY, egfrcr.derived_value
  end
end
