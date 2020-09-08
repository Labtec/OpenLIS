# frozen_string_literal: true

class LabTestValue < ApplicationRecord
  has_many :lab_test_value_option_joints, dependent: :destroy
  has_many :lab_tests, through: :lab_test_value_option_joints,
                       dependent: :nullify
  has_many :results, dependent: :nullify

  # TODO: Add LOINC Answer code validator
  # validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true
  validates :value, presence: true

  scope :sorted, -> { order(value: :asc) }

  auto_strip_attributes :value

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
