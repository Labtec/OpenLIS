# frozen_string_literal: true

class LabTestValueOptionJoint < ApplicationRecord
  belongs_to :lab_test
  belongs_to :lab_test_value
end
