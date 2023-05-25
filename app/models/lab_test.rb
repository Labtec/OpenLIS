# frozen_string_literal: true

class LabTest < ApplicationRecord
  include PublicationStatus

  belongs_to :department, touch: true
  belongs_to :unit, optional: true

  # TODO Rename to qualified_values (FHIR 5)
  has_many :qualified_intervals, -> { order(rank: :asc) }, dependent: :destroy
  has_many :lab_test_panels, dependent: :destroy
  has_many :panels, through: :lab_test_panels
  has_many :observations, dependent: :destroy
  has_many :accessions, through: :observations
  has_many :lab_test_value_option_joints, dependent: :destroy
  has_many :lab_test_values, through: :lab_test_value_option_joints
  has_many :prices, as: :priceable, dependent: :destroy

  delegate :name, to: :department, prefix: true

  accepts_nested_attributes_for :prices, allow_destroy: true

  validates :code,
            presence: true,
            uniqueness: true
  validates :department, presence: true
  validates :name, presence: true
  validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true

  acts_as_list scope: :department

  scope :sorted, -> { order(name: :asc) }
  scope :with_price, -> { includes(:prices).where.not(prices: { amount: nil }) }

  auto_strip_attributes :name, :code, :procedure, :loinc

  def self.unit_for(code)
    find_by(code: code).unit.expression
  end

  def also_allow=(also_allow)
    case also_allow
    when 'also_numeric'
      self.also_numeric = true
      self.ratio        = false
      self.range        = false
      self.fraction     = false
    when 'ratio'
      self.also_numeric = false
      self.ratio        = true
      self.range        = false
      self.fraction     = false
    when 'range'
      self.also_numeric = false
      self.ratio        = false
      self.range        = true
      self.fraction     = false
    when 'fraction'
      self.also_numeric = false
      self.ratio        = false
      self.range        = false
      self.fraction     = true
    else
      self.also_numeric = false
      self.ratio        = false
      self.range        = false
      self.fraction     = false
    end
  end

  def also_allow
    if also_numeric? && !ratio? && !range? && !fraction?
      :also_numeric
    elsif !also_numeric? && ratio? && !range? && !fraction?
      :ratio
    elsif !also_numeric? && !ratio? && range? && !fraction?
      :range
    elsif !also_numeric? && !ratio? && !range? && fraction?
      :fraction
    else
      :none
    end
  end

  def customary_unit
    unit&.ucum
  end

  def si_unit
    unit&.si
  end

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end

  # TODO: The database should store both names,
  # the plain name and the formatted name
  def stripped_name
    name.gsub(%r{</?i>}, '')
  end

  def stripped_name_with_description
    name_with_description.gsub(%r{</?i>}, '')
  end

  def allow_quantity?
    return true if also_numeric || value_default?

    false
  end

  def value_default?
    return true if !also_numeric &&
                   !ratio? &&
                   !range? &&
                   !fraction &&
                   !text_length &&
                   lab_test_values.empty?

    false
  end
end
