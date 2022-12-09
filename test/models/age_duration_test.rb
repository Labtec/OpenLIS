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

  test 'built from weeks' do
    birth_date = 6.weeks.ago
    today = Date.today

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_equal 6.weeks, age.in_weeks.round.weeks
  end

  test 'clinical adult age' do
    birth_date = 18.years.ago

    age = ActiveSupport::Duration.age(birth_date)
    assert_equal 18, age.parts[:years], 'clinical adult age'
  end

  test 'age calculations' do
    date_from = Date.parse('2020-05-14')
    date_to = Date.parse('2020-11-19')

    age = ActiveSupport::Duration.pediatric_age(date_from, date_to)
    assert_equal 27.weeks, age
  end

  test 'between months with 30 and 31 days' do
    birth_date = Date.parse('2020-09-30')
    today = Date.parse('2020-11-11')

    assert_equal 6.weeks, ActiveSupport::Duration.pediatric_age(birth_date,
                                                                today)
  end

  test 'age duration between different months' do
    # 28-day month
    birth_date = Date.parse('2001-02-28')
    today = Date.parse('2001-03-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_nil age.parts[:years], '0 years'
    assert_nil age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 days'

    # 29-day month
    birth_date = Date.parse('2000-02-29')
    today = Date.parse('2000-03-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_nil age.parts[:years], '0 years'
    assert_nil age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 days'

    # 30-day month
    birth_date = Date.parse('2000-04-29')
    today = Date.parse('2000-05-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_nil age.parts[:years], '0 years'
    assert_nil age.parts[:months], '0 months'
    assert_equal 3, age.parts[:days], '3 days'

    # 31-day month
    birth_date = Date.parse('2000-01-29')
    today = Date.parse('2000-02-02')

    age = ActiveSupport::Duration.age(birth_date, today)
    assert_nil age.parts[:years], '0 years'
    assert_nil age.parts[:months], '0 months'
    assert_equal 4, age.parts[:days], '4 days'
  end

  test 'accounts for leap years' do
    birth_date = Date.parse('2000-02-29')

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2001-03-01'))
    assert_equal 1, age.parts[:years], 'Legal one year'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2004-02-29'))
    assert_equal 4, age.parts[:years], 'Four years'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2007-02-28'))
    assert_equal 6, age.parts[:years], 'February 28,2007'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2007-03-01'))
    assert_equal 7, age.parts[:years], 'March 1,2007'

    age = ActiveSupport::Duration.age(birth_date, Date.parse('2008-02-29'))
    assert_equal 8, age.parts[:years], 'February 29, 2008'

    # 28-day month currently on a leap year
    travel_to Time.new(2020, 1, 1, 12, 0, 0, 0)
    birth_date = Date.parse('2001-02-28')
    service_date = Date.parse('2001-03-02')

    age = ActiveSupport::Duration.age(birth_date, service_date)
    assert_nil age.parts[:years], '0 years'
    assert_nil age.parts[:months], '0 months'
    assert_equal 2, age.parts[:days], '2 days'
    travel_back
  end

  test '#pediatric_age returns a pediatric age' do
    travel_to Time.new(2000, 1, 1, 12, 0, 0, 0)
    ages = [
      # [age, output],
      [27.days.ago, 27.days],
      [28.days.ago, 4.weeks],
      [29.days.ago, 4.weeks + 1.day],
      [(11.months + 30.days).ago, 52.weeks],
      [1.year.ago, 12.months],
      [(1.year + 1.day).ago, 12.months + 1.day],
      [(1.year + 8.days).ago, 12.months + 8.days],
      [(1.year + 1.month + 9.days).ago, 13.months + 10.days],
      [(4.years + 1.month + 9.days).ago, 4.years + 1.month],
      [(17.years + 11.months).ago, 17.years + 11.months],
      [(19.years + 39.days).ago, 19.years]
    ]

    ages.each do |age|
      assert_equal age[1], ActiveSupport::Duration.pediatric_age(age[0])
    end
    travel_back
  end

  test 'age duration' do
    from_to_duration = [
      # [from, to, duration],
      ['2000-01-01', '2010-12-15', 10.years + 11.months + 14.days],
      ['2000-01-01', '2010-06-15', 10.years + 5.months + 14.days],
      ['2000-04-14', '2010-06-15', 10.years + 2.months + 1.day],
      ['2000-04-15', '2010-06-15', 10.years + 2.months],
      ['2000-04-16', '2010-06-15', 10.years + 1.month + 30.days],
      ['2000-05-14', '2010-06-15', 10.years + 1.month + 1.day],
      ['2000-05-15', '2010-06-15', 10.years + 1.month],
      ['2000-05-16', '2010-06-15', 10.years + 30.days],
      ['2000-06-14', '2010-06-15', 10.years + 1.day],
      ['2000-06-15', '2010-06-15', 10.years],
      ['2000-06-16', '2010-06-15', 9.years + 11.months + 30.days],
      ['2000-07-14', '2010-06-15', 9.years + 11.months + 1.day],
      ['2000-07-15', '2010-06-15', 9.years + 11.months],
      ['2000-07-16', '2010-06-15', 9.years + 10.months + 30.days],
      ['2000-08-14', '2010-06-15', 9.years + 10.months + 1.day],
      ['2000-08-15', '2010-06-15', 9.years + 10.months],
      ['2000-08-16', '2010-06-15', 9.years + 9.months + 30.days],
      ['2000-12-31', '2010-06-15', 9.years + 5.months + 15.days],
      ['1996-02-29', '2011-02-27', 14.years + 11.months + 29.days],
      ['1996-02-29', '2011-02-28', 14.years + 11.months + 30.days],
      ['1996-02-29', '2011-03-01', 15.years + 1.day],
      ['1996-02-29', '2012-02-28', 15.years + 11.months + 30.days],
      ['1996-02-29', '2012-02-29', 16.years],
      ['1996-02-29', '2012-03-01', 16.years + 1.day]
    ]

    from_to_duration.each do |duration|
      assert_equal duration[2],
        ActiveSupport::Duration.age(Date.parse(duration[0]),
                                    Date.parse(duration[1])),
        "#{duration[0]} -- #{duration[1]}"
    end
  end
end
