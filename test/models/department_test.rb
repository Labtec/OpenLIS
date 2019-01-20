# frozen_string_literal: true

require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  test 'presence of name' do
    department = Department.create(name: '')
    assert department.errors.added?(:name, :blank)
  end

  test 'uniqueness of name' do
    department = Department.create(name: 'Chemistry')
    assert department.errors.added?(:name, :taken, value: 'Chemistry')
  end

  test 'name contains extra spaces' do
    department = Department.create(name: '  Department  ')
    assert_equal 'Department', department.name
  end

  test 'no extra spaces between names' do
    department = Department.create(name: 'General  Department')
    assert_equal 'General Department', department.name
  end
end
