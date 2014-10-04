class LabTestValue < ActiveRecord::Base
  #translates :name
  has_many :lab_test_value_option_joints
  has_many :lab_tests, through: :lab_test_value_option_joints, dependent: :nullify
  has_many :results

  scope :sorted, -> { order(value: :asc) }

  def value_with_flag
    unless flag.blank?
      value.to_s + ' (' + flag.to_s + ')'
    else
      value
    end
  end
end
