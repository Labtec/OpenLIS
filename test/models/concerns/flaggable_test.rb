# frozen_string_literal: true

require "test_helper"

class FlaggableTest < ActiveSupport::TestCase
  setup do
    @observation = observations(:observation)
  end

  test "reference low and high ranges are present" do
    lab_test = lab_tests(:qualified_interval)
    @observation.update(lab_test:)

    # Reference Range: 10-2,000
    # value = 9 => interpretation: L
    @observation.update(value: 9)
    assert_equal "L", @observation.interpretation
    # value = 10 => interpretation: N
    @observation.update(value: 10)
    assert_equal "N", @observation.interpretation
    # value = 2,000 => interpretation: N
    @observation.update(value: 2_000)
    assert_equal "N", @observation.interpretation
    # value = 2,001 > interpretation: H
    @observation.update(value: 2_001)
    assert_equal "H", @observation.interpretation
  end

  test "reference low range is present" do
    lab_test = lab_tests(:qualified_interval_greater_than)
    @observation.update(lab_test:)

    # Reference Range: >= 10
    # value = 9 => interpretation: L
    @observation.update(value: 9)
    assert_equal "L", @observation.interpretation
    # value = 10 => interpretation: N
    @observation.update(value: 10)
    assert_equal "N", @observation.interpretation
  end

  test "reference high range is present" do
    lab_test = lab_tests(:qualified_interval_less_than)
    @observation.update(lab_test:)

    # Reference Range: < 10
    # value = 9 => interpretation: N
    @observation.update(value: 9)
    assert_equal "N", @observation.interpretation
    # value = 10 => interpretation: H
    @observation.update(value: 10)
    assert_equal "H", @observation.interpretation
  end

  test "critical ranges" do
    lab_test = lab_tests(:with_critical_ranges)
    @observation.update(lab_test:)

    # Critical Low: <100
    # Significantly Low: 100-200
    # Low: 201-299
    # Desirable: 300-400
    # High: 401-499
    # Significantly High: 500-599
    # Critical High: >=600
    #
    # value = 99 => interpretation: LL
    @observation.update(value: 99)
    assert_equal "LL", @observation.interpretation
    # value = 100 => interpretation: LU
    @observation.update(value: 100)
    assert_equal "LU", @observation.interpretation
    # value = 201 => interpretation: L
    @observation.update(value: 201)
    assert_equal "L", @observation.interpretation
    # value = 300 => interpretation: N
    @observation.update(value: 300)
    assert_equal "N", @observation.interpretation
    # value = 401 => interpretation: H
    @observation.update(value: 401)
    assert_equal "H", @observation.interpretation
    # value = 500 => interpretation: HU
    @observation.update(value: 500)
    assert_equal "HU", @observation.interpretation
    # value = 600 => interpretation: HH
    @observation.update(value: 600)
    assert_equal "HH", @observation.interpretation
  end

  test "value is a range" do
    lab_test = lab_tests(:range)
    lab_test.update(qualified_intervals: [qualified_intervals(:qualified_interval)])
    @observation.update(lab_test:)

    # Reference Range: 10-2,000
    # value = 100-200 => interpretation: N
    @observation.update(value: "100-200")
    assert_equal "N", @observation.interpretation
    # value = 1-5 => interpretation: L
    @observation.update(value: "1-5")
    assert_equal "L", @observation.interpretation
    # value = 3,000-4,000 => interpretation: H
    @observation.update(value: "3000-4000")
    assert_equal "H", @observation.interpretation
  end

  test "value is a code (qualitative)" do
    lab_test = lab_tests(:qualitative)
    @observation.update(lab_test:)

    # value = Positive => interpretation: A
    @observation.update(lab_test_value: lab_test_values(:positive))
    assert_equal "A", @observation.interpretation
  end

  test "gaps in ages" do
    lab_test = lab_tests(:qualified_interval)
    # 1 day to 4 weeks (< 5 weeks)
    ri1 = QualifiedInterval.create(category: "critical", age_low: "P1D", age_high: "P5W", range_low_value: 1, range_high_value: nil)
    # 5 weeks to 2 years
    ri2 = QualifiedInterval.create(category: "critical", age_low: "P5W", age_high: "P2Y", range_low_value: 2, range_high_value: nil)
    lab_test.update(qualified_intervals: [ri1, ri2])
    patient = patients(:john)
    accession = accessions(:accession)
    accession.update(patient:, drawn_at: Time.current)
    @observation.update(accession:, lab_test:)

    patient.update(birthdate: 4.weeks.ago)
    assert_equal 1.., @observation.critical_intervals.take.range

    patient.update(birthdate: (4.weeks + 3.days).ago)
    assert_equal 1.., @observation.critical_intervals.take.range

    patient.update(birthdate: 6.weeks.ago)
    assert_equal 2.., @observation.critical_intervals.take.range
  end
end
