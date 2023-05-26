# frozen_string_literal: true

class Observation < ApplicationRecord
  include DataAbsentReason
  include Flaggable
  include ObservationStatus
  include DataAbsentReason
  include FHIRable::Observation

  belongs_to :accession
  belongs_to :lab_test
  belongs_to :lab_test_value, optional: true

  has_one :department, through: :lab_test
  has_one :patient,    through: :accession
  has_one :unit,       through: :lab_test

  has_many :notes, as: :noticeable, dependent: :destroy
  has_many :qualified_intervals, through: :lab_test

  delegate :code,        to: :lab_test, prefix: true
  delegate :decimals,    to: :lab_test, prefix: true
  delegate :derivation?, to: :lab_test
  delegate :fraction?,   to: :lab_test
  delegate :name,        to: :lab_test, prefix: true
  delegate :range?,      to: :lab_test
  delegate :ratio?,      to: :lab_test
  delegate :remarks,     to: :lab_test, prefix: true, allow_nil: true
  delegate :text_length, to: :lab_test

  validates :value, out_of_absolute_range: true, allow_nil: true
  validates :value, range: true,    allow_blank: true, if: :range?
  validates :value, fraction: true, allow_blank: true, if: :fraction?
  validates :value, ratio: true,    allow_blank: true, if: :ratio?

  scope :ordered, -> { order('lab_tests.position') }
  default_scope -> { joins(:lab_test).order('lab_tests.position ASC') }

  after_update_commit -> { broadcast_replace_later_to :results, partial: 'observations/analyte', locals: { analyte: self } }

  auto_strip_attributes :value

  def reference_ranges
    qualified_intervals.for_result(accession)
  end

  def absolute_interval
    reference_ranges.absolute.first
  end

  def reference_intervals
    reference_ranges.reference
  end

  def critical_intervals
    reference_ranges.critical
  end

  def derived_value
    dv = accession.derived_value_for(lab_test_code)
    return dv unless dv.is_a?(Numeric) && dv.finite?

    dv.round(lab_test_decimals.to_i)
  end

  def derived_remarks
    accession.derived_remarks_for(lab_test_code)
  end

  def value_codeable_concept
    lab_test_value&.value
  end

  def value_unit
    unit&.expression
  end

  # value -> valueQuantity, valueInteger, valueRange, valueRatio
  # lab_test_value -> valueCodeableConcept, valueString, valueBoolean
  # derived_value
  def value_present?
    value.present? || lab_test_value_id.present? || derived_value.present?
  end

  # value_quantity -> valueRange, valueRatio
  def value_quantity
    return unless value.present? || derived_value.present?

    if lab_test.derivation?
      derived_value
    elsif lab_test.range?
      value =~ /\A((<|>)|(\d+)(-))(\d+)\z/
      Range.new(Regexp.last_match(3).to_i, Regexp.last_match(5).to_i)
    elsif lab_test.fraction?
      value =~ %r{\A(\d+)/(\d+)\z}
      Rational(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
    elsif lab_test.ratio? # XXX: titer only
      value =~ /\A(\d+):(\d+)\z/
      Rational(Regexp.last_match(2).to_i, Regexp.last_match(1).to_i)
    else
      value.gsub(/[^\d.]/, '').to_d.round(lab_test_decimals.to_i)
    end
  end

  def value_quantity_comparator
    return if value.blank?

    case value.scan(/[^\d.]/).join.squish
    when '<'
      '<'
    when '<=', '=<', '≤'
      '≤'
    when '>=', '=>', '≥'
      '≥'
    when '>'
      '>'
    end
  end

  def value_range
    return if value.blank?
    return unless lab_test.range?

    value =~ /\A((<|>)|(\d+)(-))(\d+)\z/
    Range.new(Regexp.last_match(3).to_i, Regexp.last_match(5).to_i)
  end

  def value_ratio
    return if value.blank?
    return unless lab_test.ratio?

    value =~ /\A(\d+):(\d+)\z/
    Rational(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
  end

  def value_fraction
    return if value.blank?
    return unless lab_test.fraction?

    value =~ /\A(\d+):(\d+)\z/
    Rational(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
  end
end
