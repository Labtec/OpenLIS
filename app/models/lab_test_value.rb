# frozen_string_literal: true

class LabTestValue < ApplicationRecord
  ABNORMAL_FLAGS = %w[A AA DET E I IE IND NS POS R RR UNE WR].freeze
  HIGH_FLAGS = %w[> H HU HH].freeze
  LOW_FLAGS = %w[< L LU LL].freeze
  NORMAL_FLAGS = ["", "EXP", "N", "ND", "NEG", "NR", "S"].freeze
  FLAGS = ABNORMAL_FLAGS + HIGH_FLAGS + LOW_FLAGS + NORMAL_FLAGS

  has_many :lab_test_value_option_joints, dependent: :destroy
  has_many :lab_tests, through: :lab_test_value_option_joints,
                       dependent: :nullify
  has_many :observations, dependent: :nullify

  validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true
  validates :value, presence: true
  validates :flag, inclusion: { in: FLAGS }, allow_blank: true

  scope :sorted, -> { order(value: :asc) }

  after_create_commit -> { broadcast_prepend_later_to "admin:lab_test_values", partial: "layouts/refresh", locals: { path: Rails.application.routes.url_helpers.admin_lab_test_values_path } }
  after_update_commit -> { broadcast_replace_later_to "admin:lab_test_values" }
  after_destroy_commit -> { broadcast_remove_to "admin:lab_test_values" }

  auto_strip_attributes :value

  def raise_flag
    flag unless NORMAL_FLAGS.include?(flag)
  end

  def to_partial_path
    "admin/lab_test_values/lab_test_value"
  end

  def value_with_flag
    flag.present? ? "#{value} (#{flag})" : value
  end

  # TODO: The database should store both values,
  # the plain value and the formatted value
  def stripped_value
    value.gsub(%r{</?i>}, "")
  end

  def stripped_value_with_flag
    value_with_flag.gsub(%r{</?i>}, "")
  end
end
