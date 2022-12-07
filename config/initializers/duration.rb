# frozen_string_literal: true

module ActiveSupport
  class Duration
    class << self
      # Builds the age of a person at any given date/time.
      # If no time is given, +Time.zone.now.to_date+ is used.
      def age(from, to = Time.zone.now.to_date)
        return unless from

        return if from > to

        # Account for local time zone first, then
        # strip time information.
        from = from.in_time_zone.to_date
        to = to.in_time_zone.to_date

        fd = from.day
        fm = from.month
        td = to.day
        tm = to.month
        fy = from.year
        ty = to.year

        # Account for leap days from date.
        if fd == 29 && fm == 2 && td == 28 && tm == 2 && !Date.gregorian_leap?(ty)
          duration = (to - from).to_i + 0.2425 * (ty - fy)
        else
          duration = (to - from).to_i
        end

        # Convert duration to ISO 8601 duration format.
        duration_iso8601 = "P#{duration}D"

        # Return an ActiveSupport::Duration
        ActiveSupport::Duration.parse(duration_iso8601)
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
