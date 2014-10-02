class LabTestPanel < ActiveRecord::Base
  belongs_to :lab_test
  belongs_to :panel
end
