# frozen_string_literal: true

require 'test_helper'

class DoctorTest < ActiveSupport::TestCase
  test 'presence of name' do
    doctor = Doctor.create(name: '')
    assert doctor.errors.added?(:name, :blank)
  end

  test 'uniqueness of name' do
    doctor = Doctor.create(name: 'Doctor')
    assert doctor.errors.added?(:name, :taken, value: 'Doctor')
  end

  test 'length of name' do
    doctor = Doctor.create(name: 'D')
    assert doctor.errors.added?(:name, :too_short, count: 2)
  end

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
