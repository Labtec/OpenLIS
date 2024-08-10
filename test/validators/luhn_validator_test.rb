# frozen_string_literal: true

require "test_helper"

# https://wiki.openmrs.org/display/docs/Check+Digit+Algorithm
class LuhnValidatorTest < ActiveSupport::TestCase
  test "valid Luhn checksum" do
    assert_equal 8, Luhn.checkdigit("139MT")
    assert_equal 5, Luhn.checkdigit("12")
    assert_equal 0, Luhn.checkdigit("123")
    assert_equal 3, Luhn.checkdigit("1245496594")
    assert_equal 4, Luhn.checkdigit("TEST")
    assert_equal 7, Luhn.checkdigit("Test123")
    assert_equal 5, Luhn.checkdigit("00012")
    assert_equal 1, Luhn.checkdigit("9")
    assert_equal 3, Luhn.checkdigit("999")
    assert_equal 6, Luhn.checkdigit("999999")
    assert_equal 7, Luhn.checkdigit("CHECKDIGIT")
    assert_equal 2, Luhn.checkdigit("EK8XO5V9T8")
    assert_equal 1, Luhn.checkdigit("Y9IDV90NVK")
    assert_equal 5, Luhn.checkdigit("RWRGBM8C5S")
    assert_equal 5, Luhn.checkdigit("OBYY3LXR79")
    assert_equal 2, Luhn.checkdigit("Z2N9Z3F0K3")
    assert_equal 9, Luhn.checkdigit("ROBL3MPLSE")
    assert_equal 9, Luhn.checkdigit("VQWEWFNY8U")
    assert_equal 1, Luhn.checkdigit("45TPECUWKJ")
    assert_equal 8, Luhn.checkdigit("6KWKDFD79A")
    assert_equal 3, Luhn.checkdigit("HXNPKGY4EX")
    assert_equal 2, Luhn.checkdigit("91BT")
    error = assert_raise ArgumentError do
      Luhn.checkdigit("12/3")
    end
    assert_match "invalid character (/)", error.message
  end
end
