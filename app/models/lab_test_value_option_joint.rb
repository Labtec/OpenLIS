class LabTestValueOptionJoint < ActiveRecord::Base
  belongs_to :lab_test, inverse_of: :lab_test_value_option_joints
  belongs_to :lab_test_value, inverse_of: :lab_test_value_option_joints
end
