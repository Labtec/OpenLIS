# frozen_string_literal: true

require 'test_helper'

class ObservationStatusTest < ActiveSupport::TestCase
  setup do
    @observation = observations(:observation)
  end

  test 'starts with a registered status' do
    assert_nil @observation.value
    assert_nil @observation.lab_test_value_id
    assert_equal 'registered', @observation.status
  end

  test 'transitions from registered to registered' do
    @observation.value = nil
    @observation.lab_test_value_id = nil
    @observation.evaluate!

    assert_equal 'registered', @observation.status
  end

  test 'transitions from registered to preliminary' do
    @observation.value = 1
    @observation.lab_test_value_id = nil
    @observation.evaluate!

    assert_equal 'preliminary', @observation.status, 'Value'

    @observation.value = nil
    @observation.lab_test_value_id = 1
    @observation.evaluate!

    assert_equal 'preliminary', @observation.status, 'Value CodeableConcept'
  end

  test 'transitions from preliminary to registered' do
    @observation.value = 1
    @observation.evaluate!

    assert_equal 'preliminary', @observation.status

    @observation.value = nil
    @observation.evaluate!

    assert_equal 'registered', @observation.status
  end

  test 'transitions from preliminary to preliminary' do
    @observation.value = 1
    @observation.evaluate!

    assert_equal 'preliminary', @observation.status

    @observation.value = 2
    @observation.evaluate!

    assert_equal 'preliminary', @observation.status
  end

  test 'does not transition from registered to final' do
    @observation.value = nil
    @observation.lab_test_value_id = nil

    assert_raises AASM::InvalidTransition do
      @observation.certify!
    end

    assert_equal 'registered', @observation.status
  end

  test 'transitions a value from preliminary to final' do
    @observation.value = 1
    @observation.lab_test_value_id = nil
    @observation.evaluate!
    assert_equal 'preliminary', @observation.status
    @observation.certify!

    assert_equal 'final', @observation.status
  end

  test 'transitions a CodeableConcept from preliminary to final' do
    @observation.value = nil
    @observation.lab_test_value_id = 1
    @observation.evaluate!
    assert_equal 'preliminary', @observation.status
    @observation.certify!

    assert_equal 'final', @observation.status
  end

  test 'does not transition from final to preliminary' do
    @observation.value = 1
    @observation.evaluate!
    @observation.certify!
    assert_equal 'final', @observation.status

    @observation.value = nil
    @observation.evaluate!

    assert_equal 'amended', @observation.status
  end
end
