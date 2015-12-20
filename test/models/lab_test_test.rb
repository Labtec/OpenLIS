require 'test_helper'

class LabTestTest < ActiveSupport::TestCase
  should validate_presence_of(:code)
  should validate_uniqueness_of(:code)
  should validate_presence_of(:department)
  should validate_presence_of(:name)
end
