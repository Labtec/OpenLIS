# frozen_string_literal: true

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
      years: in_years
    }
  end

  # Age remainders for time units.
  #
  # === Returns
  #
  # A hash with the age remainders for different time units.
  def remainders
    fd = @from_date.day
    fm = @from_date.month
    td = @to_date.day
    tm = @to_date.month
    remainders = {}

    # weeks
    # remainder in days
    week_remainder = time_units[:days] - time_units[:weeks] * 7

    # months
    # remainder in days
    if fd == 29 && fm == 2 && td == 28 && tm == 2 && !leap_year?
      month_remainder = 0
    elsif fd > td
      last_month_days =
        if Time.days_in_month(@to_date.last_month.month) > fd
          Time.days_in_month(@to_date.last_month.month) - fd
        else
          0
        end
      month_remainder = last_month_days + td
    else
      month_remainder = td - fd
    end

    # years
    # remainder in months
    if fm > tm
      last_year_months = 12 - fm
      year_remainder = last_year_months + tm
    elsif fm == tm
      year_remainder = if fd == 29 && fm == 2 && td == 28 && tm == 2 && !leap_year?
                         0
                       elsif fd > td
                         11
                       else
                         0
                       end
    else
      year_remainder = tm - fm
    end

    remainders[:weeks]  = week_remainder  unless week_remainder.zero?
    remainders[:months] = month_remainder unless month_remainder.zero?
    remainders[:years]  = year_remainder  unless year_remainder.zero?

    remainders
  end

  private

  def leap_year?
    Date.gregorian_leap?(@to_date.year)
  end
end
