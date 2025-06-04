# frozen_string_literal: true

class LabTest < ApplicationRecord
  include PublicationStatus
  include FastingStatus

  belongs_to :department, touch: true
  belongs_to :unit, optional: true

  # TODO: Rename to qualified_values (FHIR 5)
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
  validates :name, presence: true
  validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true
  validates :procedure_quantity, absence: true,
                                 unless: -> { procedure.present? }
  validates :procedure_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_blank: true

  acts_as_list scope: :department

  scope :active, -> { where(status: "active") }
  scope :sorted, -> { order(name: :asc) }
  scope :with_price, -> { includes(:prices).where.not(prices: { amount: nil }) }

  after_create_commit -> { broadcast_prepend_later_to "admin:lab_tests", partial: "layouts/refresh", locals: { path: Rails.application.routes.url_helpers.admin_lab_tests_path } }
  after_update_commit -> { broadcast_replace_later_to "admin:lab_tests" }
  after_destroy_commit -> { broadcast_remove_to "admin:lab_tests" }

  after_update_commit -> { broadcast_replace_later_to "admin:lab_test", partial: "layouts/refresh", locals: { path: Rails.application.routes.url_helpers.admin_lab_test_path(self) }, target: :lab_test }
  after_destroy_commit -> { broadcast_replace_to "admin:lab_test", partial: "layouts/invalid", locals: { path: Rails.application.routes.url_helpers.admin_lab_tests_path }, target: :lab_test }

  auto_strip_attributes :name, :code, :procedure, :procedure_quantity, :loinc, :patient_preparation, :fasting_status_duration

  def self.unit_for(code)
    find_by(code:).unit.expression
  end

  def allow_quantity?
    return true if also_numeric || value_default?

    false
  end

  def also_allow=(also_allow)
    case also_allow
    when "also_numeric"
      self.also_numeric = true
      self.ratio        = false
      self.range        = false
      self.fraction     = false
    when "ratio"
      self.also_numeric = false
      self.ratio        = true
      self.range        = false
      self.fraction     = false
    when "range"
      self.also_numeric = false
      self.ratio        = false
      self.range        = true
      self.fraction     = false
    when "fraction"
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

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end

  def si_unit
    unit&.si
  end

  # TODO: The database should store both names,
  # the plain name and the formatted name
  def stripped_name
    name.gsub(%r{</?i>}, "")
  end

  def stripped_name_with_description
    name_with_description.gsub(%r{</?i>}, "")
  end

  def to_partial_path
    "admin/lab_tests/lab_test"
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
