# frozen_string_literal: true

require 'test_helper'

class PatientsAgeHelperTest < ActionView::TestCase
  include PatientsHelper

  def setup
    travel_to Time.new(2016, 2, 28, 12, 0, 0, 0)
  end

  def teardown
    travel_back
  end

  test "returns a patient's age" do
    dates = [
      # [birth_date, output],
      [27.days.ago, { days: 27 }],
      [28.days.ago, { weeks: 4 }],
      [29.days.ago, { weeks: 4, days: 1 }],
      [1.year.ago - 1.day, { months: 12, days: 1 }],
      [1.year.ago - 8.days, { months: 12, days: 8 }],
      [1.year.ago - 39.days, { months: 13, days: 8 }],
      [4.years.ago - 39.days, { years: 4, months: 1 }],
      [18.years.ago + 1.day, { years: 17, months: 11 }],
      [19.years.ago - 39.days, { years: 19 }]
    ]

    dates.each do |date|
      assert_equal date[1], age_hash(date[0])
    end
  end

  test "returns a patient's age string" do
    dates = [
      # [birth_date, output],
      [27.days.ago, '27 days'],
      [28.days.ago, '4 weeks'],
      [29.days.ago, '4 weeks 1 day'],
      [1.year.ago - 1.day, '12 months 1 day'],
      [1.year.ago - 8.days, '12 months 8 days'],
      [1.year.ago - 39.days, '13 months 8 days'],
      [4.years.ago - 39.days, '4 years 1 month'],
      [18.years.ago + 1.day, '17 years 11 months'],
      [19.years.ago - 39.days, '19 years']
    ]

    dates.each do |date|
      assert_equal date[1], age(date[0])
    end
  end

  test "returns a patient's age hash based on the service date" do
    dates = [
      # [birth_date, service_date, output],
      [30.years.ago, 5.years.ago, { years: 25 }],
      [20.years.ago, 3.years.ago, { years: 17 }],
      ['2000-10-15', '2010-10-14', { years: 9, months: 11 }],
      ['2000-10-15', '2010-10-16', { years: 10 }]
    ]

    dates.each do |date|
      assert_equal date[2], age_hash(date[0], date[1])
    end
  end
end
