# frozen_string_literal: true

module Flaggable
  extend ActiveSupport::Concern

  def interpretations
    return [lab_test_value.raise_flag] if lab_test_value.present?
    return unless value_present?

    intervals = reference_ranges.includes(:interpretation)
    return unless intervals.present?

    num = value_quantity
    flags = []

    intervals.each do |interval|
      if interval.critical?
        if interval.interpretation
          flags << interval.interpretation.flag if interval.range.cover?(num)
        elsif interval.range_low_value && (interval.range_low_value..).cover?(num)
          flags << "HH"
        elsif interval.range_high_value && (...interval.range_high_value).cover?(num)
          flags << "LL"
        end
      else
        if interval.interpretation
          flags << interval.interpretation.flag if interval.range.cover?(num)
        elsif interval.range.cover?(num)
          flags << "N"
        elsif interval.range_high_value && (interval.range_high_value..).cover?(num)
          flags << "H"
        elsif interval.range_low_value && (...interval.range_low_value).cover?(num)
          flags << "L"
        end
      end
    end

    flags
  end

  def interpretation
    flags = interpretations

    return unless flags

    # normal
    return "N" if flags.any?("N")

    # critical
    return "AA" if flags.any?("AA")
    return "LL" if flags.any?("LL")
    return "HH" if flags.any?("HH")

    # significant
    return "LU" if flags.any?("LU")
    return "HU" if flags.any?("HU")

    # interpretation
    flags.uniq[0]
  end

  def normal?
    flag = interpretation

    flag.nil? || LabTestValue::NORMAL_FLAGS.include?(flag)
  end
end
