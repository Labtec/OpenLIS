require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  test 'name contains extra spaces' do
    doctor = create(:doctor, name: '  Alice  ')
    assert_equal 'Alice', doctor.name
  end

  test 'name contains two characters or more' do
    doctor = build(:doctor, name: ' A ')
    assert_equal true, doctor.invalid?(:name)
  end

  test 'is not created twice' do
    create(:doctor, name: 'Alice')
    doctor = build(:doctor, name: ' Alice ')
    assert_equal true, doctor.invalid?(:name)
  end
end
