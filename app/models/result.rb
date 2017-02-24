class Result < ApplicationRecord
  RANGE_SYMBOLS = [RANGE_SYMBOL_RANGE = '–', RANGE_SYMBOL_LT = '<', RANGE_SYMBOL_GE = '≥']

  belongs_to :accession
  belongs_to :lab_test
  belongs_to :lab_test_value, optional: true

  has_many :notes, as: :noticeable
  has_many :reference_ranges, through: :lab_test

  has_one :department, through: :lab_test
  has_one :patient, through: :accession
  has_one :unit, through: :lab_test

  delegate :code, to: :lab_test, prefix: true
  delegate :decimals, to: :lab_test, prefix: true
  delegate :name, to: :lab_test, prefix: true
  delegate :name, to: :unit, prefix: true, allow_nil: true

  validates_format_of :value,
    message: I18n.t('flash.results.range'),
    allow_blank: true,
    with: /\A((<|>)|(\d+)(-))(\d+)\Z/,
    if: :range?

  validates_format_of :value,
    message: I18n.t('flash.results.fraction'),
    allow_blank: true,
    with: /\A(\d+)\/(\d+)\Z/,
    if: :fraction?

  validates_format_of :value,
    message: I18n.t('flash.results.ratio'),
    allow_blank: true,
    with: /\A(\d+):(\d+)\Z/,
    if: :ratio?

  def range?
    lab_test.range?
  end

  def fraction?
    lab_test.fraction?
  end

  def ratio?
    lab_test.ratio?
  end

  def derived_value
    case lab_test_code
    when 'CHOLHDLR'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      chol / hdl
    when 'GLO'
      tp = result_for 'TP'
      alb = result_for 'ALB'
      tp - alb
    when 'IBIL'
      tbil = result_for 'TBIL'
      dbil = result_for 'DBIL'
      tbil - dbil
    when 'IM'
      pr = result_for 'PR'
      np = result_for 'NP'
      100 - pr + np
    when 'LDL'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      trig = result_for 'TRIG'
      chol - hdl - 0.2 * trig
    when 'MCH'
      hgb = result_for 'HGB'
      rbc = result_for 'RBC'
      hgb / rbc * 10
    when 'MCHC'
      hgb = result_for 'HGB'
      hct = result_for 'HCT'
      hgb * 100 / hct
    when 'MCV'
      hct = result_for 'HCT'
      rbc = result_for 'RBC'
      hct / rbc * 10
    when 'NORM'
      abhead, abhead_v = result_for('ABHEAD'), value_for('ABHEAD')
      abmid, abmid_v = result_for('ABMID'), value_for('ABMID')
      abmain, abmain_v = result_for('ABMAIN'), value_for('ABMAIN')
      excesscyt, excesscyt_v = result_for('EXCESSCYT'), value_for('EXCESSCYT')
      if (abhead.blank? || abmid.blank? ||
          abmain.blank? || excesscyt.blank?) &&
        (abhead_v || abmid_v || abmain_v || excesscyt_v).present?
        abhead_v || abmid_v || abmain_v || excesscyt_v
      else
        100 - (abhead + abmid + abmain + excesscyt)
      end
    when 'TMOTILE'
      pr = result_for 'PR'
      np = result_for 'NP'
      pr + np
    when 'TSPERM'
      sconc = result_for 'SCONC'
      svol = result_for 'SVOL'
      sconc * svol
    when 'VLDL'
      trig = result_for 'TRIG'
      0.2 * trig
    end
  rescue
    'calc.'
  end

  # TODO: This method should be in Accession
  def result_for(code)
    lab_test_by_code = LabTest.find_by_code(code)
    result_value = accession.results.find_by_lab_test_id(lab_test_by_code).value
    result_value.to_d if result_value.present?
  end

  # TODO: This method should be in Accession
  def value_for(code)
    lab_test_by_code = LabTest.find_by_code(code)
    value_for_lab_test = accession.results.find_by_lab_test_id(lab_test_by_code).lab_test_value
    value_for_lab_test.value if value_for_lab_test.present?
  end

  def pending?
    return true if !lab_test_value.present? && value.blank? && !lab_test.derivation?
  end

  # SUGGESTION: min and max should be renamed to min_value and max_value to avoid clashing
  # with min and max methods for arrays.
  def ranges?
    if reference_ranges.present?
      @base_ranges ||= reference_ranges.for_its_type(patient.animal_type).for_its_gender(patient.gender).for_its_age_in_units(accession.patient_age[:days], accession.patient_age[:weeks], accession.patient_age[:months], accession.patient_age[:years])
      @range_min ||= @base_ranges.map(&:min).compact.min if @base_ranges
      @range_max ||= @base_ranges.map(&:max).compact.max if @base_ranges
      true
    else
      false
    end
  end

  def ranges
    ranges = []
    if ranges?
      @base_ranges.each do |r|
        if r.max && r.min
          range_interval_symbol = Result::RANGE_SYMBOL_RANGE
        elsif r.max
          range_interval_symbol = Result::RANGE_SYMBOL_LT
        elsif r.min
          range_interval_symbol = Result::RANGE_SYMBOL_GE
        end

        if r.description.present?
          description = r.description + ': '
        end

        unless lab_test.ratio? || lab_test.range? || lab_test.fraction? || lab_test.text_length?
          if r.max && r.min
            ranges << [description, format_value(r.min), range_interval_symbol, format_value(r.max)]
          elsif r.max
            ranges << [description, nil, range_interval_symbol, format_value(r.max)]
          elsif r.min
            ranges << [description, nil, range_interval_symbol, format_value(r.min)]
          else
            ranges << [nil]
          end
        else
          ranges << [nil]
        end
        ranges
      end
    else
      ranges << [nil]
    end
    ranges << [nil]
  end

  # TODO: rename to absolute_range
  def range
    if @range_max && @range_min
      range_interval_symbol = Result::RANGE_SYMBOL_RANGE
    elsif @range_max
      range_interval_symbol = Result::RANGE_SYMBOL_LT
    elsif @range_min
      range_interval_symbol = Result::RANGE_SYMBOL_GE
    end

    unless lab_test.ratio? || lab_test.range? || lab_test.fraction? || lab_test.text_length?
      if @range_max && @range_min
        [@range_min, range_interval_symbol, @range_max]
      elsif @range_max
        [nil, range_interval_symbol, @range_max]
      elsif @range_min
        [nil, range_interval_symbol, @range_min]
      else
        [nil, nil, nil]
      end
    else
      [nil, nil, nil]
    end
  end

  def flag
    if pending?
      nil
    elsif lab_test_value.present?
      lab_test_value.flag
    elsif lab_test.derivation?
      if derived_value == 'calc.'
        nil
      else
        check_reference_range(derived_value) if ranges?
      end
    elsif value.present?
      check_reference_range(value.to_f) if ranges?
    elsif lab_test.also_numeric?
      check_reference_range(value.to_f)
    elsif lab_test.range?
      value =~ /\A((<|>)|(\d+)(-))(\d+)\Z/
      check_reference_range([$3, $5].map(&:to_i).try(:max))
    elsif lab_test.fraction?
      value =~ /\A(\d+)\/(\d+)\Z/
      check_reference_range([$1, $2].map(&:to_i).try(:max))
    elsif lab_test.ratio?
      value =~ /\A(\d+):(\d+)\Z/
      check_reference_range([$1, $2].map(&:to_i).try(:max))
    end
  end

  def check_reference_range(numeric_value)
    min = @range_min || -Float::INFINITY
    max = @range_max || Float::INFINITY
    if numeric_value.to_f == max.to_f && @range_min.nil?
      return 'H'
    end
    case numeric_value.to_f
    when -Float::INFINITY...min.to_f then 'L'
    when min.to_f..max.to_f then nil
    when max.to_f..Float::INFINITY then 'H'
    end
  end

  def lab_test_values?
    LabTestValueOptionJoint.where(lab_test: lab_test).blank?
  end

  # TODO: Try using an enum for lab test:
  # enum result_type: [:numeric, :ratio, :range, :fraction, ...]
  def result_types?
    lab_test.also_numeric? ||
    lab_test.ratio? ||
    lab_test.range? ||
    lab_test.fraction? ||
    lab_test.text_length.present?
  end

  private

  def format_value(number)
    ApplicationController.helpers.number_with_precision(number, precision: lab_test_decimals, delimiter: ',')
  end
end
