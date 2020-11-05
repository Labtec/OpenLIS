# frozen_string_literal: true

module ActiveSupport
  class Duration
    class << self
      # Builds the age of a person at any given time.
      # If no time is given, +Time.current+ is used.
      def age(from, to = Time.zone.now)
        return unless from

        from = from.to_date

        fd = from.day
        fm = from.month
        fy = from.year
        td = to.day
        tm = to.month
        ty = to.year
        parts = {}

        # days
        if fd == 29 && fm == 2 && td == 28 && tm == 2 && !Date.gregorian_leap?(ty)
          parts[:days] = 0
        elsif fd > td
          last_month_days =
            if Time.days_in_month(to.last_month.month, to.last_month.year) > fd
              Time.days_in_month(to.last_month.month, to.last_month.year) - fd
            else
              0
            end
          parts[:days] = last_month_days + td
        else
          parts[:days] = td - fd
        end

        # months
        if fm > tm
          last_year_months = 12 - fm
          parts[:months] = last_year_months + tm
        elsif fm == tm
          parts[:months] = if fd == 29 && fm == 2 && td == 28 && tm == 2 && !Date.gregorian_leap?(ty)
                             0
                           elsif fd > td
                             11
                           else
                             0
                           end
        else
          parts[:months] = if fd > td
                             0
                           else
                             tm - fm
                           end
        end

        # years
        parts_years = ty - fy
        parts_years -= 1 if to.to_date < from + parts_years.years
        parts[:years] = parts_years

        parts[:hours] = to.to_time.hour
        parts[:minutes] = to.to_time.min
        parts[:seconds] = to.to_time.sec

        ActiveSupport::Duration.new(calculate_total_seconds(parts), parts)
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
      elsif self.parts[:years].nil? # age < 1.year
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
  end
end
