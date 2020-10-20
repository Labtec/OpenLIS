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
  has_many :reference_ranges, through: :lab_test

  delegate :code,        to: :lab_test, prefix: true
  delegate :decimals,    to: :lab_test, prefix: true
  delegate :derivation?, to: :lab_test
  delegate :fraction?,   to: :lab_test
  delegate :name,        to: :lab_test, prefix: true
  delegate :range?,      to: :lab_test
  delegate :ratio?,      to: :lab_test
  delegate :remarks,     to: :lab_test, prefix: true, allow_nil: true
  delegate :text_length, to: :lab_test

  validates :value, range: true,    allow_blank: true, if: :range?
  validates :value, fraction: true, allow_blank: true, if: :fraction?
  validates :value, ratio: true,    allow_blank: true, if: :ratio?

  scope :ordered, -> { order('lab_tests.position') }

  auto_strip_attributes :value

  def derived_value
    accession.derived_value_for(lab_test_code)
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
end
