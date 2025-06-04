# frozen_string_literal: true

require "test_helper"

class PatientsNameHelperTest < ActionView::TestCase
  include PatientsHelper

  setup do
    @patient = patients(:john)
  end

  test "display full name" do
    assert_equal "John Fitzgerald Doe Rockefeller", full_name(@patient)
  end

  test "display full legal name" do
    @patient.update(partner_name: "Morgan")
    assert_equal "John Fitzgerald Doe Morgan", full_name(@patient)
  end

  test "display name as last name comma first name without middle initial" do
    @patient.update(middle_name: "")
    assert_equal "Doe, John", name_last_comma_first_mi(@patient)
  end

  test "display name as last name comma first name with a middle initial" do
    assert_equal "Doe, John F.", name_last_comma_first_mi(@patient)
  end

  test "display name as last name comma first name without family name" do
    @patient.update(family_name: "", partner_name: "Doe")
    assert_equal "Doe, John F.", name_last_comma_first_mi(@patient)
  end

  test "if last name starts with a lowercase, uppercase when Last, First" do
    @patient.update(family_name: "nel Tomasso")
    assert_equal "Nel Tomasso, John F.", name_last_comma_first_mi(@patient)
  end

  test "if last name contains an accented letter, remove accent accordingly" do
    @patient.update(family_name: "ñel Tomasso")
    assert_equal "Nel Tomasso, John F.", name_last_comma_first_mi(@patient)
  end

  test "label display name truncates first name with more than 9 characters" do
    @patient.update(given_name: "Fitzgerald")
    assert_equal "Doe, Fitzgera+ F", name_last_comma_first_mi_label(@patient)
  end

  test "label display name truncates last name with more than 13 characters" do
    @patient.update(family_name: "Fontainebleau")
    assert_equal "Fontainebleau, John F", name_last_comma_first_mi_label(@patient)

    @patient.update(family_name: "De La Fontaine")
    assert_equal "De La Fontai+, John F", name_last_comma_first_mi_label(@patient)
  end

  test "#animal_species_name" do
    animal_species = { other: 0, canine: 1, feline: 2, equine: 3 }
    animal_species.each do |k, v|
      assert_equal t("patients.#{k}"), animal_species_name(v)
    end
  end
end
