# frozen_string_literal: true

require 'test_helper'

class ResultsHelperTest < ActionView::TestCase
  include ResultsHelper

  setup do
    @result = results(:result)
  end

  test 'format pending result' do
    assert_equal 'pend.', format_value(@result)
  end

  test 'format quantitative result' do
    @result.value = 10
    assert_equal '10', format_value(@result)

    @result.value = 1000
    assert_equal '1,000', format_value(@result)

    @result.lab_test = lab_tests(:decimal)
    assert_equal '1,000.0', format_value(@result)
  end

  test 'format qualitative result' do
    @result.update(lab_test: lab_tests(:qualitative),
                   lab_test_value: lab_test_values(:positive))
    assert_equal 'Positive', format_value(@result)
  end

  test 'format qualitative result with escaped characters' do
    @result.update(lab_test: lab_tests(:qualitative),
                   lab_test_value: lab_test_values(:less_than))
    assert_equal '< 10', format_value(@result)

    @result.lab_test_value = lab_test_values(:greater_than)
    assert_equal '> 10', format_value(@result)
  end

  test 'format mixed result' do
    @result.update(lab_test: lab_tests(:mixed),
                   value: 10,
                   lab_test_value: lab_test_values(:positive))
    assert_equal 'Positive [10]', format_value(@result)

    @result.value = 1000
    assert_equal 'Positive [1,000]', format_value(@result)

    @result.lab_test_value = lab_test_values(:less_than)
    assert_equal '< 10 [1,000]', format_value(@result)
  end

  test 'format ratio result' do
    @result.update(lab_test: lab_tests(:ratio),
                   value: '1:2')
    assert_equal '1∶2', format_value(@result)
  end

  test 'format range result' do
    @result.update(lab_test: lab_tests(:range),
                   value: '1-2')
    assert_equal '1–2', format_value(@result)
  end

  test 'format fraction result' do
    @result.update(lab_test: lab_tests(:fraction),
                   value: '1/2')
    assert_equal '1 ∕ 2', format_value(@result)
  end

  test 'format text result' do
    @result.update(lab_test: lab_tests(:text),
                   value: 'This is the result')
    assert_equal 'This is the result', format_value(@result)
  end
end
