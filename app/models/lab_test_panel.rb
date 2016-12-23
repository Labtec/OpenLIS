class LabTestPanel < ApplicationRecord
  belongs_to :lab_test, inverse_of: :lab_test_panels
  belongs_to :panel, inverse_of: :lab_test_panels
end
