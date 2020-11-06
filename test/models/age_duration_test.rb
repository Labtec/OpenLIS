# frozen_string_literal: true

require 'test_helper'

class AgeDurationTest < ActiveSupport::TestCase
  test '#value' do
    birth_date = Date.parse('2000-01-01')
    today = Date.parse('2001-01-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    duration = ActiveSupport::Duration.parse(age.iso8601)
    assert_equal duration.value, age.value, 'values do not match'
  end

  test 'age duration between different months' do
    # 28-day month
    birth_date = Date.parse('2001-02-28')
    today = Date.parse('2001-03-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_equal 0, age.parts[:years], '0 years'
    assert_equal 0, age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 day'

    # 29-day month
    birth_date = Date.parse('2000-02-29')
    today = Date.parse('2000-03-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_equal 0, age.parts[:years], '0 years'
    assert_equal 0, age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 days'

    # 30-day month
    birth_date = Date.parse('2000-04-29')
    today = Date.parse('2000-05-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_equal 0, age.parts[:years], '0 years'
    assert_equal 0, age.parts[:months], '0 months'
    assert_equal 3, age.parts[:days], '3 days'

    # 31-day month
    birth_date = Date.parse('2000-01-29')
    today = Date.parse('2000-02-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_equal 0, age.parts[:years], '0 years'
    assert_equal 0, age.parts[:months], '0 months'
    assert_equal 4, age.parts[:days], '4 days'
  end

  test 'accounts for leap years' do
    birth_date = Date.parse('2000-02-29')

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2001-02-28'))
    assert_equal 1, age.parts[:years], 'Legal one year'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2001-03-01'))
    assert_equal 1, age.parts[:years], 'Technical one year'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2004-02-29'))
    assert_equal 4, age.parts[:years], 'Four years'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2007-02-28'))
    assert_equal 7, age.parts[:years], 'February 28,2007'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2008-02-29'))
    assert_equal 8, age.parts[:years], 'February 29, 2008'

    # 28-day month currently on a leap year
    travel_to Time.new(2020, 1, 1, 12, 0, 0, 0)
    birth_date = Date.parse('2001-02-28')
    service_date = Date.parse('2001-03-02')

    age = ActiveSupport::Duration.age(birth_date, service_date)
    assert_equal 0, age.parts[:years], '0 years'
    assert_equal 0, age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 day'
    travel_back
  end

  test '#pediatric returns a pediatric age' do
    ages = [
      # [age, output],
      [27.days, 27.days],
      [28.days, 4.weeks],
      [29.days, 4.weeks + 1.day],
      [11.months + 30.days, 52.weeks],
      [11.months + 30.days + 23.hours + 59.seconds, 52.weeks + 1.day],
      [1.year, 12.months],
      [1.year + 1.day, 12.months + 1.day],
      [1.year + 8.days, 12.months + 8.days],
      [1.year + 1.month + 9.days, 13.months + 9.days],
      [4.years + 1.month + 9.days, 4.years + 1.month],
      [17.years + 11.months, 17.years + 11.months],
      [19.years + 39.days, 19.years]
    ]

    ages.each do |age|
      assert_equal age[1], age[0].pediatric
    end
  end
end
