# Calculates the age of a person at any given time.
# If no time is given, +Time.current+ is used.
class AgeCalculator
  def initialize(from_date, to_date = Time.current)
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
    in_months = in_seconds / 1.month.seconds
    in_years = @to_date.year - @from_date.year
    in_years -= 1 if @to_date < @from_date + in_years.years

    {
      seconds: in_seconds,
      days: in_days,
      weeks: in_weeks,
      months: in_months,
      years: in_years,
    }
  end

  # Age remainders for time units.
  #
  # === Returns
  #
  # A hash with the age remainders for different time units.
  def remainders
    bd, bm = @from_date.day, @from_date.month
    dd, dm, dy = @to_date.day, @to_date.month, @to_date.year

    # weeks
    # remainder in days
    week_remainder = time_units[:days] - time_units[:weeks] * 7

    # months
    # remainder in days
    if bd == 29 && bm == 2 && dd == 28 && dm == 2 && !Date.gregorian_leap?(dy)
      month_remainder = 0
    elsif bd > dd
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
    # remainder in months
    if bm > dm
      last_year_months = 12 - bm
      year_remainder = last_year_months + dm
    elsif bm == dm
      if bd == 29 && bm == 2 && dd == 28 && dm == 2 && !Date.gregorian_leap?(dy)
        year_remainder = 0
      elsif bd > dd
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
