require 'test_helper'

class PatientTitleizeNamesTest < ActiveSupport::TestCase
  test 'given name contains international character' do
    patient = create(:patient, given_name: 'ángel')
    assert_equal('Ángel', patient.given_name)
  end

  test 'given name contains extra spaces' do
    patient = create(:patient, given_name: '  alice  ')
    assert_equal('Alice', patient.given_name)
  end

  test 'middle name contains international character' do
    patient = create(:patient, middle_name: 'ángel')
    assert_equal('Ángel', patient.middle_name)
  end

  test 'middle name contains extra spaces' do
    patient = create(:patient, middle_name: '  alice  ')
    assert_equal('Alice', patient.middle_name)
  end

  test 'family name contains extra spaces' do
    patient = create(:patient, family_name: '  Doe  ')
    assert_equal('Doe', patient.family_name)
  end

  test 'family name2 contains extra spaces' do
    patient = create(:patient, family_name2: '  Doe  ')
    assert_equal('Doe', patient.family_name2)
  end

  test 'identifier contains extra spaces' do
    patient = create(:patient, identifier: '  12345  ')
    assert_equal('12345', patient.identifier)
  end

  test 'phone contains extra spaces' do
    patient = create(:patient, phone: '  555-5555  ')
    assert_equal('555-5555', patient.phone)
  end

  test 'address contains extra spaces' do
    patient = create(:patient, address: '  123  Elm  St.  ')
    assert_equal('123 Elm St.', patient.address)
  end

  test 'policy number contains extra spaces' do
    patient = create(:patient, policy_number: '  12345  ')
    assert_equal('12345', patient.policy_number)
  end
end
