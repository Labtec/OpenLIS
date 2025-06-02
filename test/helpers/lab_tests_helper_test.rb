# frozen_string_literal: true

require "test_helper"

class LabTestsHelperTest < ActionView::TestCase
  include LabTestsHelper

  test "format procedure code" do
    procedure = "11111"
    quantity = nil

    assert_equal "11111", show_procedure(procedure, quantity)

    quantity = 1
    assert_equal "11111", show_procedure(procedure, quantity)

    quantity = 2
    assert_equal "11111×2", show_procedure(procedure, quantity)
  end
end
