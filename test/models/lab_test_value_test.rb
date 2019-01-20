# frozen_string_literal: true

require 'test_helper'

class LabTestValueTest < ActiveSupport::TestCase
  test 'presence of value' do
    lab_test_value = LabTestValue.create(value: '')
    assert lab_test_value.errors.added?(:value, :blank)
  end

  test 'value contains extra spaces' do
    lab_test_value = LabTestValue.create(value: '  Lab Test Value  ')
    assert_equal 'Lab Test Value', lab_test_value.value
  end

  test 'no extra spaces within value' do
    lab_test_value = LabTestValue.create(value: 'Lab  Test  Value')
    assert_equal 'Lab Test Value', lab_test_value.value
  end
end
