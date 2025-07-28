# frozen_string_literal: true

require "test_helper"

class CedulaValidatorTest < ActiveSupport::TestCase
  setup do
    @patient = patients(:john)

    @patient.identifier_type = 1
    @patient.identifier = "8-1-1"
  end

  test "valid cedula format" do
    @patient.identifier = "8-1-1"
    assert @patient.valid?, "Identifier should be valid"
  end

  test "valid cedula format (max)" do
    @patient.identifier = "8-9999-99999"
    assert @patient.valid?, "TE max"

    @patient.identifier = "8-9999-999999999"
    assert @patient.valid?, "DGI max"
  end

  test "valid cedula format (NT)" do
    @patient.identifier = "8-NT-1-1"
    assert @patient.valid?
  end

  test "valid cedula format (E)" do
    @patient.identifier = "E-1-1"
    assert @patient.valid?
  end

  test "valid cedula format (N)" do
    @patient.identifier = "N-1-1"
    assert @patient.valid?
  end

  test "valid cedula format (PE)" do
    @patient.identifier = "PE-1-1"
    assert @patient.valid?
  end

  test "valid cedula format (PI)" do
    @patient.identifier = "8PI-1-1"
    assert @patient.valid?
  end

  test "valid cedula format (AV)" do
    @patient.identifier = "8AV-1-1"
    assert @patient.valid?
  end

  # TODO: Waiting for SVI access
  # test "invalid cedula format and error message" do
  #   @patient.identifier = "8-XX-1-1"
  #   assert @patient.invalid?, "Cedula should be invalid"
  #   assert @patient.errors[:identifier].any?,
  #          "A patient with an invalid cedula should contain an error"
  #   assert_equal [ "is invalid" ], @patient.errors["identifier"],
  #                "An invalid cedula error message is expected"
  # end
  #
  # test "invalid cedula format (max + 1)" do
  #   @patient.identifier = "8-10000-1000000000"
  #   assert @patient.invalid?
  # end
end
