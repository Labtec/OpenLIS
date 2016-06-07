require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  test 'name contains extra spaces' do
    department = Department.create(name: '  Department  ')
    assert_equal 'Department', department.name
  end

  test 'no extra spaces between names' do
    department = Department.create(name: 'General  Department')
    assert_equal 'General Department', department.name
  end
end
