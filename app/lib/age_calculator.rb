# Calculates the age of a person at any given time.
# If no time is given, +Time.now+ is used.
class AgeCalculator
  def initialize(from_date, to_date = Time.now)
    @from_date = from_date.in_time_zone if from_date.respond_to?(:in_time_zone)
    @to_date = to_date.in_time_zone if to_date.respond_to?(:in_time_zone)
  end

  # Age in time units.
  #
  # === Returns
  #
  # A hash with the age in different time units.
  def time_units
    in_seconds = (@to_date - @from_date).round
    in_days = in_seconds / 1.day.seconds
    in_weeks = in_seconds / 1.week.seconds
    in_months = in_seconds / 1.month.seconds # FIXME: This seems wrong
    in_years = (@to_date.to_s(:number).to_i -
                @from_date.to_s(:number).to_i) / 10e9.to_i

    {
      seconds: in_seconds,
      days: in_days,
      weeks: in_weeks,
      months: in_months,
      years: in_years,
    }
  end

  # Age remainders in time units.
  #
  # === Returns
  #
  # A hash with the age in different time units.
  def remainders
    bd, bm, = @from_date.day, @from_date.month
    dd, dm, = @to_date.day, @to_date.month

    # weeks
    # FIXME: This fails on leapday
    week_remainder = time_units[:days] - time_units[:weeks] * 7

    # months
    if bd > dd
      last_month_days =
        if Time.days_in_month(@to_date.last_month.month) > bd
          Time.days_in_month(@to_date.last_month.month) - bd
        else
          0
        end
      month_remainder = last_month_days + dd
    else
      month_remainder = dd - bd
    end

    # years
    if bm > dm
      last_year_months = 12 - bm
      year_remainder = last_year_months + dm
    elsif bm == dm
      if bd > dd
        year_remainder = 11
      else
        year_remainder = 0
      end
    else
      year_remainder = dm - bm
    end

    {
      weeks: nilify(week_remainder),
      months: nilify(month_remainder),
      years: nilify(year_remainder),
    }
  end

  private

  # If the remainder is zero, make it +nil+ instead.
  def nilify(remainder)
    remainder.zero? ? nil : remainder
  end
end
