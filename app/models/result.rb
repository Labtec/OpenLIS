class Result < ActiveRecord::Base
  RANGE_SYMBOLS = [RANGE_SYMBOL_RANGE = "–", RANGE_SYMBOL_LT = "<", RANGE_SYMBOL_GE = "≥"]

  belongs_to :accession
  belongs_to :lab_test
  belongs_to :lab_test_value
  has_many :reference_ranges, :through => :lab_test
  has_many :notes, :as => :noticeable

  delegate :department, :to => :lab_test
  delegate :patient, :to => :accession

  validates_format_of :value,
    :message => I18n.t('flash.results.range'),
    :allow_blank => true,
    :with => /\A((<|>)|(\d+)(-))(\d+)\Z/,
    :if => :range?

  validates_format_of :value,
    :message => I18n.t('flash.results.fraction'),
    :allow_blank => true,
    :with => /\A(\d+)\/(\d+)\Z/,
    :if => :fraction?

  validates_format_of :value,
    :message => I18n.t('flash.results.ratio'),
    :allow_blank => true,
    :with => /\A(\d+):(\d+)\Z/,
    :if => :ratio?

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
    begin
      case lab_test.code
      when "CHOLHDLR"
        chol = result_for "CHOL"
        hdl = result_for "HDL"
        chol / hdl
      when "GLO"
        tp = result_for "TP"
        alb = result_for "ALB"
        tp - alb
      when "IBIL"
        tbil = result_for "TBIL"
        dbil = result_for "DBIL"
        tbil - dbil
      when "IM"
        pr = result_for "PR"
        np = result_for "NP"
        100 - pr + np
      when "LDL"
        chol = result_for "CHOL"
        hdl = result_for "HDL"
        trig = result_for "TRIG"
        chol - hdl - 0.2 * trig
      when "MCH"
        hgb = result_for "HGB"
        rbc = result_for "RBC"
        hgb / rbc * 10
      when "MCHC"
        hgb = result_for "HGB"
        hct = result_for "HCT"
        hgb * 100 / hct
      when "MCV"
        hct = result_for "HCT"
        rbc = result_for "RBC"
        hct / rbc * 10
      when "NORM"
        abhead = result_for "ABHEAD"
        abmid = result_for "ABMID"
        abmain = result_for "ABMAIN"
        excesscyt = result_for "EXCESSCYT"
        100 - (abhead + abmid + abmain + excesscyt)
      when "TMOTILE"
        pr = result_for "PR"
        np = result_for "NP"
        pr + np
      when "TSPERM"
        sconc = result_for "SCONC"
        svol = result_for "SVOL"
        sconc * svol
      when "VLDL"
        trig = result_for "TRIG"
        0.2 * trig
      end
    rescue
      "calc."
    end
  end

  def result_for(code)
    lab_test_by_code = accession.lab_tests.with_code(code).first
    result_value = accession.results.find_by_lab_test_id(lab_test_by_code).value
    result_value.to_d if result_value.present?
  end

  def pending?
    return true if !lab_test_value && value.blank? && !lab_test.derivation
  end

  def units
    if lab_test.unit
      lab_test.unit.name unless lab_test_value && value.blank?
    end
  end

  # SUGGESTION: min and max should be renamed to min_value and max_value to avoid clashing
  # with min and max methods for arrays.
  def has_ranges?
    if reference_ranges.present?
      @base_ranges ||= reference_ranges.for_its_type(patient.animal_type).for_its_gender(accession.patient.gender).for_its_age_in_units(accession.patient_age[:days], accession.patient_age[:weeks], accession.patient_age[:months], accession.patient_age[:years])
      @range_min ||= @base_ranges.map(&:min).compact.min if @base_ranges
      @range_max ||= @base_ranges.map(&:max).compact.max if @base_ranges
      true
    else
      false
    end
  end

  def ranges
    ranges = []
    if has_ranges?
      @base_ranges.each_with_index do |r, i|
        if r.max && r.min
          range_interval_symbol = Result::RANGE_SYMBOL_RANGE
        elsif r.max
          range_interval_symbol = Result::RANGE_SYMBOL_LT
        elsif r.min
          range_interval_symbol = Result::RANGE_SYMBOL_GE
        end

        if r.description.present?
          description = r.description + ": "
        end

        unless lab_test.ratio? || lab_test.range? || lab_test.fraction? || lab_test.text_length?
          if r.max && r.min
            ranges << [ description, format_value(r.min), range_interval_symbol, format_value(r.max) ]
          elsif r.max
            ranges << [ description, nil, range_interval_symbol, format_value(r.max) ]
          elsif r.min
            ranges << [ description, nil, range_interval_symbol, format_value(r.min) ]
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

  #TODO: rename to absolute_range
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
    elsif value.present?
      check_reference_range(value.to_d) if has_ranges?
    elsif lab_test.also_numeric?
      check_reference_range(value.to_d)
    elsif lab_test.range?
      value =~ /\A((<|>)|(\d+)(-))(\d+)\Z/
      check_reference_range([$3, $5].map {|n| n.to_i}.try(:max))
    elsif lab_test.fraction?
      value =~ /\A(\d+)\/(\d+)\Z/
      check_reference_range([$1, $2].map {|n| n.to_i}.try(:max))
    elsif lab_test.ratio?
      value =~ /\A(\d+):(\d+)\Z/
      check_reference_range([$1, $2].map {|n| n.to_i}.try(:max))
    end
  end

  def check_reference_range(numeric_value)
    #range_min = range[0].to_number || (range[2].to_number if range[1] == Result::RANGE_SYMBOL_GE)
    #range_max = range[2].to_number unless range[1] == Result::RANGE_SYMBOL_GE
    min = @range_min || -1/0.0
    max = @range_max || 1/0.0
    if numeric_value.to_f == max.to_f && @range_min.nil?
      return "H"
    end
    case numeric_value.to_f
    when -1/0.0...min.to_f then "L"
    when min.to_f..max.to_f then nil
    when max.to_f..1/0.0 then "H"
    end
  end

  def formatted_value
    if lab_test.derivation?
      ApplicationController.helpers.number_with_precision(derived_value, :precision => lab_test.decimals, :delimiter => ',')
    elsif lab_test_value && !value.blank?
      lab_test_value.value +
      " [" +
      ApplicationController.helpers.number_with_precision(value, :precision => lab_test.decimals, :delimiter => ',') +
      "]"
    elsif lab_test_value
      lab_test_value.value
    elsif value.blank?
      "pend."
    elsif lab_test.ratio?
      value.gsub(/[:]/, '∶')
    elsif lab_test.range?
      value.gsub(/[-]/, '–')
    elsif lab_test.fraction?
      value.gsub(/[\/]/, ' ∕ ')
    elsif lab_test.text_length?
      value
    else
      ApplicationController.helpers.number_with_precision(value, :precision => lab_test.decimals, :delimiter => ',')
    end
  end

private

  def format_value(number)
    ApplicationController.helpers.number_with_precision(number, :precision => lab_test.decimals, :delimiter => ',')
  end
end
