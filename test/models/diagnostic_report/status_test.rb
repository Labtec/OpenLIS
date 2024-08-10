# frozen_string_literal: true

require "test_helper"

class DiagnosticcertifyStatusTest < ActiveSupport::TestCase
  setup do
    @diagnostic_report = accessions(:accession)
    @result = @diagnostic_report.results.first
  end

  test "starts with a registered status" do
    assert @diagnostic_report.no_values?
    assert_equal "registered", @diagnostic_report.status
  end

  test "transitions from registered to registered" do
    assert @diagnostic_report.no_values?
    @diagnostic_report.evaluate!

    assert_equal "registered", @diagnostic_report.status
  end

  test "transitions from registered to preliminary" do
    @result.value = 1
    @result.evaluate!
    assert @diagnostic_report.complete?
    @diagnostic_report.evaluate!

    assert_equal "preliminary", @diagnostic_report.status
  end

  test "transitions from preliminary to registered" do
    @result.value = 1
    @result.evaluate!
    assert @diagnostic_report.complete?
    @diagnostic_report.evaluate!
    assert_equal "preliminary", @diagnostic_report.status
    @result.value = nil
    @result.evaluate!
    @diagnostic_report.evaluate!

    assert_equal "registered", @diagnostic_report.status
  end

  test "transitions from preliminary to preliminary" do
    @result.value = 1
    @result.evaluate!
    assert @diagnostic_report.complete?
    @diagnostic_report.evaluate!
    assert_equal "preliminary", @diagnostic_report.status
    @result.value = 2
    @result.evaluate!
    @diagnostic_report.evaluate!

    assert_equal "preliminary", @diagnostic_report.status
  end

  test "does not transition from registered to final" do
    assert_raises AASM::InvalidTransition do
      @diagnostic_report.certify!
    end

    assert_equal "registered", @diagnostic_report.status
  end

  test "transitions from preliminary to final" do
    @result.value = 1
    @result.evaluate!
    assert @diagnostic_report.complete?
    @diagnostic_report.evaluate!
    assert_equal "preliminary", @diagnostic_report.status
    @diagnostic_report.certify!

    assert_equal "final", @diagnostic_report.status
  end

  test "does not transition from final to preliminary" do
    @result.value = 1
    @result.evaluate!
    assert @diagnostic_report.complete?, "Not complete"
    @diagnostic_report.evaluate!
    assert_equal "preliminary", @diagnostic_report.status, "Not preliminary"
    @diagnostic_report.certify!
    assert_equal "final", @diagnostic_report.status, "Not final"
    @result.value = nil
    @result.evaluate!
    @diagnostic_report.evaluate!

    assert_equal "amended", @diagnostic_report.status, "Not amended"
  end
end
