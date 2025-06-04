# frozen_string_literal: true

require "test_helper"

class PatientsAgeHelperTest < ActionView::TestCase
  include PatientsHelper

  def setup
    travel_to Time.new(2016, 2, 28, 12, 0, 0, 0)
  end

  test "returns a pediatric age string" do
    travel_to Time.new(2000, 1, 1, 12, 0, 0, 0)
    ages = [
      # [age, output],
      [ ActiveSupport::Duration.pediatric_age(0.days.ago), "0 days" ],
      [ ActiveSupport::Duration.pediatric_age(27.days.ago), "27 days" ],
      [ ActiveSupport::Duration.pediatric_age(28.days.ago), "4 weeks" ],
      [ ActiveSupport::Duration.pediatric_age(29.days.ago), "4 weeks 1 day" ],
      [ ActiveSupport::Duration.pediatric_age((11.months + 30.days).ago), "52 weeks" ],
      [ ActiveSupport::Duration.pediatric_age(1.year.ago), "12 months" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 1.day).ago), "12 months 1 day" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 8.days).ago), "12 months 8 days" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 1.month + 9.days).ago), "13 months 10 days" ],
      [ ActiveSupport::Duration.pediatric_age((4.years + 1.month + 9.days).ago), "4 years 1 month" ],
      [ ActiveSupport::Duration.pediatric_age((17.years + 11.months).ago), "17 years 11 months" ],
      [ ActiveSupport::Duration.pediatric_age((19.years + 39.days).ago), "19 years" ]
    ]

    ages.each do |age|
      assert_equal age[1], display_pediatric_age(age[0])
    end
    travel_back
  end

  test "returns a pediatric age string for use in labels" do
    travel_to Time.new(2000, 1, 1, 12, 0, 0, 0)
    ages = [
      # [age, output],
      [ ActiveSupport::Duration.pediatric_age(0.days.ago), "0d" ],
      [ ActiveSupport::Duration.pediatric_age(27.days.ago), "27d" ],
      [ ActiveSupport::Duration.pediatric_age(28.days.ago), "4w" ],
      [ ActiveSupport::Duration.pediatric_age(29.days.ago), "4w1d" ],
      [ ActiveSupport::Duration.pediatric_age((11.months + 30.days).ago), "52w" ],
      [ ActiveSupport::Duration.pediatric_age(1.year.ago), "12m" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 1.day).ago), "12m1d" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 8.days).ago), "12m8d" ],
      [ ActiveSupport::Duration.pediatric_age((1.year + 1.month + 9.days).ago), "13m10d" ],
      [ ActiveSupport::Duration.pediatric_age((4.years + 1.month + 9.days).ago), "4y1m" ],
      [ ActiveSupport::Duration.pediatric_age((17.years + 11.months).ago), "17y11m" ],
      [ ActiveSupport::Duration.pediatric_age((19.years + 39.days).ago), "19y" ]
    ]

    ages.each do |age|
      assert_equal age[1], display_pediatric_age_label(age[0])
    end
    travel_back
  end
end
