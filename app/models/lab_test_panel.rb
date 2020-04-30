# frozen_string_literal: true

class LabTestPanel < ApplicationRecord
  belongs_to :lab_test, touch: true
  belongs_to :panel, touch: true
end
