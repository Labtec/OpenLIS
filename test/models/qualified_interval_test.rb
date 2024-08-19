# frozen_string_literal: true

require "test_helper"

class QualifiedIntervalTest < ActiveSupport::TestCase
  setup do
    @observation = observations(:observation)
    @qualified_interval = qualified_intervals(:qualified_interval)
  end

  # <10 and 2-3
  test "flag of a lab test with multiple intervals including a nil min interval" do
    @observation.update(lab_test: lab_tests(:multiple_intervals_nil_min_interval),
                        value: 1)
    assert_equal "N", @observation.interpretation
  end

  test "flag of a lab test with multiple intervals including a nil max interval" do
    @observation.update(lab_test: lab_tests(:multiple_intervals_nil_max_interval),
                        value: 10)
    assert_equal "N", @observation.interpretation
  end

  test "flag of a lab test with a nil max interval" do
    @observation.update(lab_test: lab_tests(:qualified_interval_greater_than))

    @observation.update(value: 1)
    assert_equal "L", @observation.interpretation

    @observation.update(value: 11)
    assert_equal "N", @observation.interpretation
  end

  test "flag of a rounded lab test" do
    lab_test = lab_tests(:qualified_interval_greater_than)
    @observation.update(lab_test: lab_test)

    @observation.update(value: 9.4)
    assert_equal "L", @observation.interpretation

    @observation.update(value: 9.5)
    assert_equal "N", @observation.interpretation
  end

  test "flag of a lab test with min and max intervals" do
    @observation.update(lab_test: lab_tests(:qualified_interval))

    @observation.update(value: 1)
    assert_equal "L", @observation.interpretation

    @observation.update(value: 500)
    assert_equal "N", @observation.interpretation

    @observation.update(value: 5_000)
    assert_equal "H", @observation.interpretation

    @observation.update(value: "1,000")
    assert_equal "N", @observation.interpretation, "value contains a comma"
  end

  test "high flag of a value-range observation_definition with max interval" do
    lab_test = lab_tests(:range)
    lab_test.update(qualified_intervals: [ qualified_intervals(:less_than) ])
    @observation.update(lab_test: lab_test, value: "8-9")

    assert_equal "N", @observation.interpretation, "highest value is less than 10"

    @observation.update(value: "10-11")

    assert_equal "H", @observation.interpretation, "highest value is greater than 10"
  end

  test "#range" do
    # 1 - 2
    qualified_interval = QualifiedInterval.new(range_low_value: 1, range_high_value: 2)
    assert_equal 1..2, qualified_interval.range

    # >= 1
    qualified_interval = QualifiedInterval.new(range_low_value: 1)
    assert_equal 1.., qualified_interval.range

    # < 2
    qualified_interval = QualifiedInterval.new(range_high_value: 2)
    assert_equal (...2), qualified_interval.range
  end

  test "#age" do
    # 1 - 2 years
    @qualified_interval.update(age_low: "P1Y", age_high: "P2Y")
    assert_equal 1.year..2.years, @qualified_interval.age

    # 1 - 2 months
    @qualified_interval.update(age_low: "P1M", age_high: "P2M")
    assert_equal 1.month..2.months, @qualified_interval.age

    # 1 - 2 weeks
    @qualified_interval.update(age_low: "P1W", age_high: "P2W")
    assert_equal 1.week..2.weeks, @qualified_interval.age

    # 1 - 2 days
    @qualified_interval.update(age_low: "P1D", age_high: "P2D")
    assert_equal 1.day..2.days, @qualified_interval.age

    # > 1 day
    @qualified_interval.update(age_low: "P1D", age_high: nil)
    assert_equal 1.day.., @qualified_interval.age

    # <= 2 days
    @qualified_interval.update(age_low: nil, age_high: "P2D")
    assert_equal (...2.days), @qualified_interval.age
  end

  test "#gestational_age" do
    # 1 - 2 years
    @qualified_interval.update(gestational_age_low: "P1Y", gestational_age_high: "P2Y")
    assert_equal 1.year..2.years, @qualified_interval.gestational_age

    # 1 - 2 months
    @qualified_interval.update(gestational_age_low: "P1M", gestational_age_high: "P2M")
    assert_equal 1.month..2.months, @qualified_interval.gestational_age

    # 1 - 2 weeks
    @qualified_interval.update(gestational_age_low: "P1W", gestational_age_high: "P2W")
    assert_equal 1.week..2.weeks, @qualified_interval.gestational_age

    # 1 - 2 days
    @qualified_interval.update(gestational_age_low: "P1D", gestational_age_high: "P2D")
    assert_equal 1.day..2.days, @qualified_interval.gestational_age

    # > 1 day
    @qualified_interval.update(gestational_age_low: "P1D", gestational_age_high: nil)
    assert_equal 1.day.., @qualified_interval.gestational_age

    # <= 2 days
    @qualified_interval.update(gestational_age_low: nil, gestational_age_high: "P2D")
    assert_equal (...2.days), @qualified_interval.gestational_age
  end

  test "flag of a rounded derivation" do
    chol = observations(:observation_chol)
    hdl = observations(:observation_hdl)
    trig = observations(:observation_trig)
    ldl = observations(:observation_ldl)

    # ldl = chol - (hdl + trig / 5)
    chol.update(value: 200)
    hdl.update(value: 99)
    trig.update(value: 5)

    assert_equal 100, ldl.value_quantity
    assert_equal "H", ldl.interpretation

    hdl.update(value: 99.6)
    assert_equal 99, ldl.value_quantity
    assert_equal "N", ldl.interpretation

    hdl.update(value: 99.4)
    assert_equal 100, ldl.value_quantity
    assert_equal "H", ldl.interpretation
  end
end
