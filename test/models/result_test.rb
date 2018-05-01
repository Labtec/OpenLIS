# frozen_string_literal: true

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  setup do
    @result = results(:result)
  end

  test 'text value contains extra spaces' do
    @result.update(lab_test: lab_tests(:text),
                   value: '  Result Value  ')
    assert_equal 'Result Value', @result.value
  end

  test 'no extra spaces between text value words' do
    @result.update(lab_test: lab_tests(:text),
                   value: 'Result  Value')
    assert_equal 'Result Value', @result.value
  end
end
