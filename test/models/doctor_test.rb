require 'test_helper'

class DoctorTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_length_of(:name).is_at_least(2)

  test 'name contains extra spaces' do
    doctor = Doctor.create(name: '  Alice  ')
    assert_equal 'Alice', doctor.name
  end

  test 'no extra spaces between names' do
    doctor = Doctor.create(name: 'Alice  Feelgood')
    assert_equal 'Alice Feelgood', doctor.name
  end

  test 'name contains two characters or more' do
    doctor = Doctor.new(name: ' A ')
    assert_equal true, doctor.invalid?(:name)
  end
end
