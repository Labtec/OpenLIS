# frozen_string_literal: true

module ActiveSupport
  class Duration
    class << self
      # Builds the age of a person at any given date/time.
      # If no time is given, +Time.zone.today+ is used.
      def age(from, to = Time.zone.today)
        return unless from

        from = from.in_time_zone.to_date
        to = to.in_time_zone.to_date

        return if from > to

        fd = from.day
        fm = from.month
        fy = from.year
        td = to.day
        tm = to.month
        ty = to.year

        if fd > td
          tm -= 1
          td += Time.days_in_month(to.last_month.month, fy)
        end

        if fm > tm
          ty -= 1
          tm += 12
        end

        (ty - fy).years + (tm - fm).months + (td - fd).days
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
      def pediatric_age(from, to = Time.zone.today)
        return unless from

        from = from.in_time_zone.to_date
        to = to.in_time_zone.to_date

        return if from > to

        days = (to - from).to_i
        seconds = days * SECONDS_PER_DAY
        age = self.age(from, to)

        if seconds < 4.weeks
          days.days
        elsif age.parts[:years].nil? # age < 1.year
          weeks = days / 7
          days %= 7

          weeks.weeks + days.days
        elsif age.parts[:years] == 1 # age < 2.years
          months = (age.parts[:years].to_i * 12) + age.parts[:months].to_i
          days = age.parts[:days].to_i

          months.months + days.days
        elsif age.parts[:years] < 18 # age < 18.years
          years = age.parts[:years].to_i
          months = age.parts[:months].to_i

          years.years + months.months
        else # >= 18 years
          age.parts[:years].years
        end
      end
    end
  end
end
