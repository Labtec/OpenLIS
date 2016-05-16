require 'test_helper'

class AgeCalculatorTest < ActiveSupport::TestCase
  test 'accounts for leap years' do
    birth_date = Date.parse('2000-02-29')

    age = AgeCalculator.new(birth_date, Date.parse('2001-02-28'))
    patient_age = age.time_units
    assert_equal 1, patient_age[:years], 'Legal one year (in years)'
    assert_equal 365, patient_age[:days], 'Legal one year (in days)'

    age = AgeCalculator.new(birth_date, Date.parse('2001-03-01'))
    patient_age = age.time_units
    assert_equal 1, patient_age[:years], 'Technical one year (in years)'
    assert_equal 366, patient_age[:days], 'Technical one year (in days)'

    age = AgeCalculator.new(birth_date, Date.parse('2004-02-29'))
    patient_age = age.time_units
    assert_equal 4, patient_age[:years], 'Four years (in years)'
    assert_equal (365 * 4 + 1), patient_age[:days], 'Four years (in days)'

    age = AgeCalculator.new(birth_date, Date.parse('2007-02-28'))
    patient_age = age.time_units
    assert_equal 7, patient_age[:years], 'February 28,2007'

    age = AgeCalculator.new(birth_date, Date.parse('2008-02-29'))
    patient_age = age.time_units
    assert_equal 8, patient_age[:years], 'February 29, 2008'
  end

  test 'remainders' do
    birth_date = Date.parse('2001-01-01')

    age = AgeCalculator.new(birth_date, Date.parse('2002-01-01'))
    remainder = age.remainders
    assert_nil remainder[:years], 'Years nil remainder (in months)'
    assert_nil remainder[:months], 'Months nil remainder (in days)'
    assert_equal 1, remainder[:weeks], 'Weeks nil remainder (in days)'

    birth_date = Date.parse('2001-01-01')

    age = AgeCalculator.new(birth_date, Date.parse('2010-10-10'))
    remainder = age.remainders
    assert_equal 9, remainder[:years], 'Years remainder (in months)'
    assert_equal 9, remainder[:months], 'Months remainder (in days)'
    assert_equal 6, remainder[:weeks], 'Weeks remainder (in days)'

    birth_date = Date.parse('2000-02-29')

    age = AgeCalculator.new(birth_date, Date.parse('2001-02-28'))
    remainder = age.remainders
    assert_nil remainder[:years], 'Leap years remainder (in months)'
    assert_nil remainder[:months], 'Leap months remainder (in days)'
    assert_equal 1, remainder[:weeks], 'Leap weeks remainder (in days)'
  end
end
