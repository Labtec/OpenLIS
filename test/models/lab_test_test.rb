# frozen_string_literal: true

require 'test_helper'

class LabTestTest < ActiveSupport::TestCase
  test 'presence of code' do
    lab_test = LabTest.create(code: '')
    assert lab_test.errors.added?(:code, :blank)
  end

  test 'presence of department' do
    lab_test = LabTest.create(department: nil)
    assert lab_test.errors.added?(:department, :blank)
  end

  test 'presence of name' do
    lab_test = LabTest.create(name: '')
    assert lab_test.errors.added?(:name, :blank)
  end

  test 'uniqueness of code' do
    lab_test = LabTest.create(code: 'BUN')
    assert lab_test.errors.added?(:code, :taken, value: 'BUN')
  end

  test 'length of LOINC' do
    lab_test = LabTest.create(loinc: '0123456789')
    assert_not lab_test.errors.added?(:loinc, :too_long)

    lab_test = LabTest.create(loinc: '01234567890')
    assert lab_test.errors.added?(:loinc, :too_long, count: 10)
  end

  test 'name contains extra spaces' do
    lab_test = LabTest.create(name: '  Lab Test  ')
    assert_equal 'Lab Test', lab_test.name
  end

  test 'no extra spaces between names' do
    lab_test = LabTest.create(name: 'Lab  Test')
    assert_equal 'Lab Test', lab_test.name
  end
end
