# frozen_string_literal: true

require "test_helper"

class QualifiedIntervalsHelperTest < ActionView::TestCase
  include QualifiedIntervalsHelper

  test "reference range symbol" do
    range_less_than = qualified_intervals(:less_than).range # < 10
    range_greater_than_or_equal_to = qualified_intervals(:greater_than).range # >= 10
    range = qualified_intervals(:qualified_interval).range # 10-2,000

    assert_equal "<", range_symbol(range_less_than), "Less-than"
    assert_equal "≥", range_symbol(range_greater_than_or_equal_to), "Greater than or equal to"
    assert_equal "–", range_symbol(range), "En-dash"
  end
end
