# frozen_string_literal: true

require 'test_helper'

class PatientsAgeHelperTest < ActionView::TestCase
  include PatientsHelper

  def setup
    travel_to Time.new(2016, 2, 28, 12, 0, 0, 0)
  end

  test 'returns a pediatric age string' do
    ages = [
      # [age, output],
      [0.days, '0 days'],
      [27.days, '27 days'],
      [28.days, '4 weeks'],
      [29.days, '4 weeks 1 day'],
      [11.months + 30.days, '52 weeks'],
      [11.months + 30.days + 23.hours + 59.seconds, '52 weeks 1 day'],
      [1.year, '12 months'],
      [1.year + 1.day, '12 months 1 day'],
      [1.year + 8.days, '12 months 8 days'],
      [1.year + 1.month + 9.days, '13 months 9 days'],
      [4.years + 1.month + 9.days, '4 years 1 month'],
      [17.years + 11.months, '17 years 11 months'],
      [19.years + 39.days, '19 years']
    ]

    ages.each do |age|
      assert_equal age[1], display_pediatric_age(age[0])
    end
  end
end
