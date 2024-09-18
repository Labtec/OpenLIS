# frozen_string_literal: true

require "test_helper"

class ObservationsHelperTest < ActionView::TestCase
  include ObservationsHelper
  include QualifiedIntervalsHelper

  setup do
    @observation = observations(:observation)
  end

  test "format pending observation" do
    assert_equal "pend.", format_value(@observation)
  end

  test "format quantitative observation" do
    @observation.value = 10
    assert_equal "10", format_value(@observation)

    @observation.value = 1000
    assert_equal "1,000", format_value(@observation)

    @observation.lab_test = lab_tests(:decimal)
    assert_equal "1,000.0", format_value(@observation)

    @observation.value = "> 1000"
    assert_equal ">1,000.0", format_value(@observation)

    @observation.value = ">=1000"
    assert_equal "≥1,000.0", format_value(@observation)
  end

  test "format qualitative observation" do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:positive))
    assert_equal "Positive", format_value(@observation)
  end

  test "format qualitative observation with escaped characters" do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:less_than))
    assert_equal "< 10", format_value(@observation)

    @observation.lab_test_value = lab_test_values(:greater_than)
    assert_equal "> 10", format_value(@observation)
  end

  test "format qualitative observation marked-up with html" do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:html))
    assert_equal "<i>E. coli</i>", format_value(@observation)
  end

  test "format mixed observation" do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: 10,
                        lab_test_value: lab_test_values(:positive))
    assert_equal "Positive [10]", format_value(@observation)

    @observation.value = 1000
    assert_equal "Positive [1,000]", format_value(@observation)

    @observation.lab_test_value = lab_test_values(:less_than)
    assert_equal "< 10 [1,000]", format_value(@observation)
  end

  test "format ratio observation" do
    @observation.update(lab_test: lab_tests(:ratio),
                        value: "1:2")
    assert_equal "1∶2", format_value(@observation)
  end

  test "format range observation" do
    @observation.update(lab_test: lab_tests(:range),
                        value: "1-2")
    assert_equal "1–2", format_value(@observation)
  end

  test "format fraction observation" do
    @observation.update(lab_test: lab_tests(:fraction),
                        value: "1/2")
    assert_equal "1 ∕ 2", format_value(@observation)
  end

  test "format text observation" do
    @observation.update(lab_test: lab_tests(:text),
                        value: "This is the observation")
    assert_equal "This is the observation", format_value(@observation)
  end

  test "qualitative-only observations should not have units" do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: nil,
                        lab_test_value: lab_test_values(:positive))
    assert_not display_units(@observation)
  end

  test "numerical-qualitative observations should have units" do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: nil,
                        lab_test_value: lab_test_values(:less_than))
    assert display_units(@observation)
    assert_equal "Units", format_units(@observation)
  end

  test "quantitative observations should have units" do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: 10,
                        lab_test_value: lab_test_values(:positive))
    assert display_units(@observation)
    assert_equal "Units", format_units(@observation)
  end

  test "empty ranges table" do
    empty_table = [[nil, nil, nil, nil, nil]]
    assert_equal empty_table, ranges_table([])
  end

  test "reference range table" do
    reference_range_table = [[nil, "", "10", "–", "2,000"]]
    assert_equal reference_range_table, ranges_table([qualified_intervals(:qualified_interval)])
  end

  test "reference range table with genders" do
    reference_range_table = [[nil, "M:", "0", "–", "10"],
                             [nil, "F:", "100", "–", "200"]]
    assert_equal reference_range_table,
                 ranges_table([qualified_intervals(:gender_male), qualified_intervals(:gender_female)], display_gender: true)
  end

  test "reference range table with condition" do
    reference_range_table = [["Desirable:", "", "300", "–", "400"]]
    assert_equal reference_range_table, ranges_table([qualified_intervals(:desirable)])
  end

  test "#range_row" do
    range = qualified_intervals(:qualified_interval)
    assert_equal [nil, "", "10", "–", "2,000"], range_row(range), "Quantity"

    range.update(lab_test: lab_tests(:ratio))
    assert_equal [nil, "", "1∶10", "–", "1∶2,000"], range_row(range), "Ratio/Titer"

    range.update(lab_test: lab_tests(:range))
    assert_equal [nil, "", "10", "–", "2,000"], range_row(range), "Range/HPF"
  end
end
