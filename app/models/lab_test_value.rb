class LabTestValue < ActiveRecord::Base
  #translates :name
  has_many :lab_test_value_option_joints, inverse_of: :lab_test_value
  has_many :lab_tests, through: :lab_test_value_option_joints, dependent: :nullify
  has_many :results, inverse_of: :lab_test_value

  scope :sorted, -> { order(value: :asc) }

  def value_with_flag
    unless flag.blank?
      value.to_s + ' (' + flag.to_s + ')'
    else
      value
    end
  end
end
