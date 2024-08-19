# frozen_string_literal: true

require "test_helper"

class LOINCValidatorTest < ActiveSupport::TestCase
  test "valid LOINC format" do
    t = lab_tests(:bun)
    t.loinc = "123"

    assert t.invalid?, "LOINC should be invalid"
    assert t.errors[:loinc].any?,
           "A test/panel with an invalid LOINC should contain an error"
    assert_equal [ "is invalid" ], t.errors["loinc"],
                 "An invalid LOINC error message is expected"

    t.loinc = "123-0"
    assert t.valid?, "LOINC should be valid"

    t.loinc = "LA6576-8"
    assert t.valid?, "LOINC answer should be valid"
  end
end
