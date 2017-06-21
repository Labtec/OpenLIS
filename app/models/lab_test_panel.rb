# frozen_string_literal: true

class LabTestPanel < ApplicationRecord
  belongs_to :lab_test
  belongs_to :panel
end
