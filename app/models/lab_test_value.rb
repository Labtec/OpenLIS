class LabTestValue < ApplicationRecord
  has_many :lab_test_value_option_joints, inverse_of: :lab_test_value
  has_many :lab_tests, through: :lab_test_value_option_joints,
                       dependent: :nullify
  has_many :results, inverse_of: :lab_test_value

  scope :sorted, -> { order(value: :asc) }

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
