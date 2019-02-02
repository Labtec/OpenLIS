# frozen_string_literal: true

require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  test 'presence of code' do
    panel = Panel.create(code: '')
    assert panel.errors.added?(:code, :blank)
  end

  test 'presence of name' do
    panel = Panel.create(name: '')
    assert panel.errors.added?(:name, :blank)
  end

  test 'uniqueness of code' do
    panel = Panel.create(code: 'PANEL')
    assert panel.errors.added?(:code, :taken, value: 'PANEL')
  end

  test 'length of LOINC' do
    panel = Panel.create(loinc: '0123456789')
    assert_not panel.errors.added?(:loinc, :too_long)

    panel = Panel.create(loinc: '01234567890')
    assert panel.errors.added?(:loinc, :too_long, count: 10)
  end

  test 'name contains extra spaces' do
    panel = Panel.create(name: '  Panel  ')
    assert_equal 'Panel', panel.name
  end

  test 'no extra spaces between names' do
    panel = Panel.create(name: 'General  Panel')
    assert_equal 'General Panel', panel.name
  end
end
