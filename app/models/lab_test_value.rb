# frozen_string_literal: true

class LabTestValue < ApplicationRecord
  ABNORMAL_FLAGS = %w[A AA DET E I IND NS POS R RR WR].freeze
  HIGH_FLAGS = %w[> H HH].freeze
  LOW_FLAGS = %w[< L LL].freeze
  NORMAL_FLAGS = %w[N ND NEG NR S].freeze
  FLAGS = ABNORMAL_FLAGS + HIGH_FLAGS + LOW_FLAGS + NORMAL_FLAGS

  has_many :lab_test_value_option_joints, dependent: :destroy
  has_many :lab_tests, through: :lab_test_value_option_joints,
                       dependent: :nullify
  has_many :results, dependent: :nullify

  # TODO: Add LOINC Answer code validator
  # validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true
  validates :value, presence: true
  validates :flag, inclusion: { in: FLAGS }, allow_blank: true

  scope :sorted, -> { order(value: :asc) }

  auto_strip_attributes :value

  def raise_flag
    flag unless NORMAL_FLAGS.include?(flag)
  end

  def value_with_flag
    if flag.blank?
      value
    else
      "#{value} (#{flag})"
    end
  end

  # TODO: The database should store both values,
  # the plain value and the formatted value
  def stripped_value
    value.gsub(%r{</?i>}, '')
  end
end
