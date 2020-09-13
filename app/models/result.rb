# frozen_string_literal: true

class Result < ApplicationRecord
  RANGE_SYMBOLS = [RANGE_SYMBOL_RANGE = '–', RANGE_SYMBOL_LT = '<', RANGE_SYMBOL_GE = '≥'].freeze

  belongs_to :accession
  belongs_to :lab_test
  belongs_to :lab_test_value, optional: true

  has_many :notes, as: :noticeable, dependent: :destroy
  has_many :reference_ranges, through: :lab_test

  has_one :department, through: :lab_test
  has_one :patient,    through: :accession
  has_one :unit,       through: :lab_test

  delegate :code,        to: :lab_test, prefix: true
  delegate :decimals,    to: :lab_test, prefix: true
  delegate :derivation?, to: :lab_test
  delegate :fraction?,   to: :lab_test
  delegate :name,        to: :lab_test, prefix: true
  delegate :name,        to: :unit,     prefix: true, allow_nil: true
  delegate :range?,      to: :lab_test
  delegate :ratio?,      to: :lab_test
  delegate :remarks,     to: :lab_test, prefix: true, allow_nil: true
  delegate :text_length, to: :lab_test

  validates :value, range: true,    allow_blank: true, if: :range?
  validates :value, fraction: true, allow_blank: true, if: :fraction?
  validates :value, ratio: true,    allow_blank: true, if: :ratio?

  scope :ordered, -> { order('lab_tests.position') }

  auto_strip_attributes :value, if: :text_length

  def derived_value
    case lab_test_code
    when 'AG'
      na = result_for 'Na'
      cl = result_for 'Cl'
      co2 = result_for 'CO2'
      na - (cl + co2)
    when 'BUNCRER'
      bun = result_for 'BUN'
      cre = result_for 'CRE'
      bun / cre
    when 'CHOLHDLR'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      chol / hdl
    when 'CRETCLEAR24H'
      urncret = result_for 'URNCRET'
      cret = result_for 'CRET'
      uvol24h = result_for 'UVOL24H'
      uvol24h * urncret / cret / 1440
    when 'LDLHDLR'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      trig = result_for 'TRIG'
      ldl = case unit_for('LDL').downcase
            when 'mg/dl'
              chol - (hdl + trig / 5)
            when 'mmol/l'
              chol - (hdl + trig / 2.2)
            else
              raise
            end
      ldl / hdl
    when 'NHDCH'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      chol - hdl
    when 'GLO'
      tp = result_for 'TP'
      alb = result_for 'ALB'
      tp - alb
    when 'ALBGLO'
      alb = result_for 'ALB'
      a1_glo = result_for 'A1-GLO'
      a2_glo = result_for 'A2-GLO'
      b_glo = result_for 'B-GLO'
      g_glo = result_for 'G-GLO'
      glo1 = a1_glo + a2_glo + b_glo + g_glo
      tp = result_for 'TP'
      glo2 = tp - alb
      glo = glo1.zero? ? glo2 : glo1
      alb / glo
    when 'IBIL'
      tbil = result_for 'TBIL'
      dbil = result_for 'DBIL'
      tbil - dbil
    when 'IM'
      pr = result_for 'PR'
      np = result_for 'NP'
      100 - (pr + np)
    when 'LDL'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      trig = result_for 'TRIG'
      case unit.name.downcase
      when 'mg/dl'
        chol - (hdl + trig / 5)
      when 'mmol/l'
        chol - (hdl + trig / 2.2)
      else
        raise
      end
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
      abhead = result_for('ABHEAD')
      abhead_v = value_for('ABHEAD')
      abmid = result_for('ABMID')
      abmid_v = value_for('ABMID')
      abmain = result_for('ABMAIN')
      abmain_v = value_for('ABMAIN')
      excesscyt = result_for('EXCESSCYT')
      excesscyt_v = value_for('EXCESSCYT')
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
    when 'TPU24H'
      uprot24h = result_for 'UPROT24H'
      uvol24h = result_for 'UVOL24H'
      uprot24h * uvol24h / 100
    when 'TSPERM'
      sconc = result_for 'SCONC'
      svol = result_for 'SVOL'
      sconc * svol
    when 'VLDL'
      trig = result_for 'TRIG'
      0.2 * trig
    end
  rescue StandardError
    'calc.'
  end

  # TODO: This method should be in Accession
  def result_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    result_value = accession.results.find_by(lab_test_id: lab_test_by_code).value
    result_value.to_d if result_value.present?
  end

  # TODO: This method should be in Accession
  def unit_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    unit_for_lab_test = accession.results.find_by(lab_test_id: lab_test_by_code).unit.name
    unit_for_lab_test.presence
  end

  # TODO: This method should be in Accession
  def value_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    value_for_lab_test = accession.results.find_by(lab_test_id: lab_test_by_code).lab_test_value
    value_for_lab_test.value if value_for_lab_test.present?
  end

  def pending?
    lab_test_value.blank? && value.blank? && !derivation?
  end

  # SUGGESTION: min and max should be renamed to min_value and max_value to avoid clashing
  # with min and max methods for arrays.
  def ranges?
    @base_ranges ||= reference_ranges.for_its_type(patient.animal_type).for_its_gender(patient.gender).for_its_age_in_units(accession.patient_age[:days], accession.patient_age[:weeks], accession.patient_age[:months], accession.patient_age[:years]) if reference_ranges.present?
    @range_min ||= @base_ranges.map(&:min).map(&:to_f).compact.min if @base_ranges.present?
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
    if pending?
      nil
    elsif lab_test_value.present?
      lab_test_value.raise_flag
    elsif lab_test.derivation?
      if derived_value == 'calc.'
        nil
      elsif ranges?
        check_reference_range(derived_value)
      end
    elsif value.present?
      check_reference_range(value.gsub(/[^\d.]/, '').to_f) if ranges?
    elsif lab_test.also_numeric?
      check_reference_range(value.gsub(/[^\d.]/, '').to_f)
    elsif lab_test.range?
      value =~ /\A((<|>)|(\d+)(-))(\d+)\z/
      check_reference_range([Regexp.last_match(3), Regexp.last_match(5)].map(&:to_i).try(:max))
    elsif lab_test.fraction?
      value =~ %r{\A(\d+)/(\d+)\z}
      check_reference_range([Regexp.last_match(1), Regexp.last_match(2)].map(&:to_i).try(:max))
    elsif lab_test.ratio?
      value =~ /\A(\d+):(\d+)\z/
      check_reference_range([Regexp.last_match(1), Regexp.last_match(2)].map(&:to_i).try(:max))
    end
  end

  def check_reference_range(numeric_value)
    min = @range_min || -Float::INFINITY
    max = @range_max || Float::INFINITY
    return 'H' if numeric_value.to_f == max.to_f && @range_min.nil?

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
      ratio? || range? || fraction? || text_length.present?
  end

  private

  def format_value(number)
    ApplicationController.helpers.number_with_precision(number, precision: lab_test_decimals, delimiter: ',')
  end
end
