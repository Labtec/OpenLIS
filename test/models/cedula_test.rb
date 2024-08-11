# frozen_string_literal: true

require "test_helper"

class CedulaTest < ActiveSupport::TestCase
  test "digito verificador" do
    assert_equal "47", Cedula.new("8-NT-1-1").dv
    assert_equal "50", Cedula.new("8-1223-601").dv
    assert_equal "91", Cedula.new("8-274-125").dv
    assert_equal "61", Cedula.new("8-274-1253").dv
    assert_equal "63", Cedula.new("E-1-11").dv
    assert_equal "64", Cedula.new("N-1-11").dv
    assert_equal "60", Cedula.new("PE-1-19").dv
    assert_equal "05", Cedula.new("8-PI-1-80").dv
    assert_equal "60", Cedula.new("8-AV-1-80").dv
  end
end
