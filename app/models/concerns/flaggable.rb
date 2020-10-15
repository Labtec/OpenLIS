# frozen_string_literal: true

module Flaggable
  extend ActiveSupport::Concern

  RANGE_SYMBOLS = [RANGE_SYMBOL_RANGE = '–', RANGE_SYMBOL_LT = '<', RANGE_SYMBOL_GE = '≥'].freeze

  # SUGGESTION: min and max should be renamed to min_value and max_value to avoid clashing
  # with min and max methods for arrays.
  def ranges?
    @base_ranges ||= reference_ranges.for_its_type(patient.animal_type).for_its_gender(patient.gender).for_its_age_in_units(accession.patient_age[:days], accession.patient_age[:weeks], accession.patient_age[:months], accession.patient_age[:years]) if reference_ranges.present?
    @range_min ||= @base_ranges.map(&:min).map(&:to_d).compact.min if @base_ranges.present?
    @range_max ||= @base_ranges.map(&:max).map { |b| b || Float::INFINITY }.compact.max if @base_ranges.present?

    @base_ranges.present?
  end

  def ranges
    ranges = []
    if ranges?
      @base_ranges.each do |r|
        gender = "#{r.gender}: " if patient.gender == 'U' && r.gender != '*'
        description = "#{r.description}: " if r.description.present?

        ranges << if ratio? || range? || fraction? || text_length
                    [nil]
                  elsif lab_test_value && !lab_test_value.numeric? && value.blank?
                    [nil]
                  elsif r.max && r.min
                    [gender, description, format_value(r.min), RANGE_SYMBOL_RANGE, format_value(r.max)]
                  elsif r.max
                    [gender, description, nil, RANGE_SYMBOL_LT, format_value(r.max)]
                  elsif r.min
                    [gender, description, nil, RANGE_SYMBOL_GE, format_value(r.min)]
                  else
                    [nil]
                  end
      end
    else
      ranges << [nil]
    end

    ranges
  end

  # TODO: rename to absolute_range
  def range
    if ratio? || range? || fraction? || text_length
      [nil, nil, nil]
    elsif @range_max && @range_min
      [@range_min, RANGE_SYMBOL_RANGE, @range_max]
    elsif @range_max
      [nil, RANGE_SYMBOL_LT, @range_max]
    elsif @range_min
      [nil, RANGE_SYMBOL_GE, @range_min]
    else
      [nil, nil, nil]
    end
  end

  def flag
    if !value_present?
      nil
    elsif lab_test_value.present?
      lab_test_value.raise_flag
    elsif lab_test.derivation?
      if derived_value.nil?
        nil
      elsif ranges?
        check_reference_range(derived_value)
      end
    elsif ranges?
      if lab_test.also_numeric?
        check_reference_range(value.gsub(/[^\d.]/, '').to_d)
      elsif lab_test.range?
        value =~ /\A((<|>)|(\d+)(-))(\d+)\z/
        check_reference_range([Regexp.last_match(3), Regexp.last_match(5)].map(&:to_i).try(:max))
      elsif lab_test.fraction?
        value =~ %r{\A(\d+)/(\d+)\z}
        check_reference_range([Regexp.last_match(1), Regexp.last_match(2)].map(&:to_i).try(:max))
      elsif lab_test.ratio?
        value =~ /\A(\d+):(\d+)\z/
        check_reference_range([Regexp.last_match(1), Regexp.last_match(2)].map(&:to_i).try(:max))
      elsif value.present?
        check_reference_range(value.gsub(/[^\d.]/, '').to_d)
      end
    end
  end

  def check_reference_range(numeric_value)
    min = @range_min || -Float::INFINITY
    max = @range_max || Float::INFINITY
    return 'H' if numeric_value.to_d == max.to_d && @range_min.nil?

    case numeric_value.to_d
    when -Float::INFINITY...min.to_d then 'L'
    when min.to_d..max.to_d then nil
    when max.to_d..Float::INFINITY then 'H'
    end
  end

  private

  def format_value(number)
    ApplicationController.helpers.number_with_precision(number, precision: lab_test_decimals, delimiter: ',')
  end
end
