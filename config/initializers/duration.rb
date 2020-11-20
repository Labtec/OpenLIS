# frozen_string_literal: true

module ActiveSupport
  class Duration
    class << self
      # Builds the age of a person at any given date/time.
      # If no time is given, +Date.today+ is used.
      def age(from, to = Date.today)
        return unless from

        from = from.to_date
        to = to.to_date

        fd = from.day
        fm = from.month
        td = to.day
        tm = to.month
        ty = to.year

        if fd == 29 && fm == 2 && td == 28 && tm == 2 && !Date.gregorian_leap?(ty)
          ActiveSupport::Duration.build(((to - from) * SECONDS_PER_DAY) + 1.day)
        else
          ActiveSupport::Duration.build((to - from) * SECONDS_PER_DAY)
        end
      end

      private

      def calculate_total_seconds(parts)
        parts.inject(0) do |total, (part, value)|
          total + value * ActiveSupport::Duration::PARTS_IN_SECONDS[part]
        end
      end
    end

    # Returns a pediatric age duration.
    #
    # Parts to be used when displaying a pediatric age:
    #
    #     | Age         | Lower Part | Higher Part |
    #     | ----------- | ---------- | ----------- |
    #     | < 2 hours   | minutes    | minutes     |
    #     | < 2 days    | hours      | hours       |
    #     | < 4 weeks   | days       | days        |
    #     | < 1 year    | weeks      | days        |
    #     | < 2 years   | months     | days        |
    #     | < 18 years  | years      | months      |
    #     | >= 18 years | years      | years       |
    def pediatric
      if self < 4.weeks
        self.in_days.floor.days
      elsif self.parts[:years].zero? # age < 1.year
        age_in_weeks = self.in_weeks.floor.weeks
        age_in_days  = (self - age_in_weeks).in_days.floor.days

        age_in_weeks + age_in_days
      elsif self.parts[:years] == 1 # age < 2.years
        age_in_months = self.in_months.floor.months
        age_in_days  = (self - age_in_months).in_days.floor.days

        age_in_months + age_in_days
      elsif self.parts[:years] < 18 # age < 18.years
        age_in_years = self.parts[:years].years
        age_in_months = self.parts[:months].to_i.months

        age_in_years + age_in_months
      else # >= 18 years
        self.parts[:years].years
      end
    end

    alias :in_seconds :to_i

    # Returns the amount of minutes a duration covers as a float
    #
    #   1.day.in_minutes # => 1440.0
    def in_minutes
      in_seconds / SECONDS_PER_MINUTE.to_f
    end

    # Returns the amount of hours a duration covers as a float
    #
    #   1.day.in_hours # => 24.0
    def in_hours
      in_seconds / SECONDS_PER_HOUR.to_f
    end

    # Returns the amount of days a duration covers as a float
    #
    #   12.hours.in_days # => 0.5
    def in_days
      in_seconds / SECONDS_PER_DAY.to_f
    end

    # Returns the amount of weeks a duration covers as a float
    #
    #   2.months.in_weeks # => 8.696
    def in_weeks
      in_seconds / SECONDS_PER_WEEK.to_f
    end

    # Returns the amount of months a duration covers as a float
    #
    #   9.weeks.in_months # => 2.07
    def in_months
      in_seconds / SECONDS_PER_MONTH.to_f
    end

    # Returns the amount of years a duration covers as a float
    #
    #   30.days.in_years # => 0.082
    def in_years
      in_seconds / SECONDS_PER_YEAR.to_f
    end
  end
end
