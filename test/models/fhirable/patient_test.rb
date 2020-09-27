# frozen_string_literal: true

require 'test_helper'

class FHIRablePatientTest < ActiveSupport::TestCase
  test 'patient json file is valid' do
    json = file_fixture('patient-example.json').read
    patient = FHIR.from_contents(json)

    assert patient.valid?
  end

  test 'patient xml is valid' do
    xml = file_fixture('patient-example.xml').read
    patient = FHIR.from_contents(xml)

    assert patient.valid?
  end

  test 'imported patient from json maps to OpenLIS' do
    json = file_fixture('patient-example.json').read
    patient = Patient.new_from_fhir(json)

    assert_equal 'Peter', patient.given_name
    assert_equal 'James', patient.middle_name
    assert_equal 'Chalmers', patient.family_name
    assert_equal 'M', patient.gender
    assert_equal Date.new(1974, 12, 25), patient.birthdate
    assert_equal '12345', patient.identifier
    assert_not patient.deceased?
  end

  test 'imported patient from json is valid' do
    json = file_fixture('patient-example.json').read
    patient = Patient.new_from_fhir(json)

    assert patient.valid?
  end

  test 'imported animal patient from json maps to OpenLIS' do
    json = file_fixture('patient-example-animal.json').read
    patient = Patient.new_from_fhir(json)

    assert_equal 'Kenzi', patient.given_name
    assert_equal 'F', patient.gender
    assert_equal Date.new(2010, 3, 23), patient.birthdate
    assert_equal '1234123', patient.identifier
    assert_equal 1, patient.animal_type
  end
end
