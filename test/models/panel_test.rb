# frozen_string_literal: true

require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  should validate_presence_of(:code)
  should validate_uniqueness_of(:code)
  should validate_presence_of(:name)
  should validate_length_of(:loinc).is_at_most(10)

  test 'name contains extra spaces' do
    panel = Panel.create(name: '  Panel  ')
    assert_equal 'Panel', panel.name
  end

  test 'no extra spaces between names' do
    panel = Panel.create(name: 'General  Panel')
    assert_equal 'General Panel', panel.name
  end
end
