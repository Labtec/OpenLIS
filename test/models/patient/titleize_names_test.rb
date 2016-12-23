require 'test_helper'

class PatientTitleizeNamesTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.new(
      given_name: 'John',
      family_name: 'Doe',
      gender: 'M',
      birthdate: 30.years.ago
    )
  end

  test 'given name contains international character' do
    @patient.given_name = 'ángel'

    @patient.save!
    assert_equal 'Ángel', @patient.given_name
  end

  test 'given name contains extra spaces' do
    @patient.given_name = '  alice  '

    @patient.save!
    assert_equal 'Alice', @patient.given_name
  end

  test 'middle name contains international character' do
    @patient.middle_name = 'ángel'

    @patient.save!
    assert_equal 'Ángel', @patient.middle_name
  end

  test 'middle name contains extra spaces' do
    @patient.middle_name = '  alice  '

    @patient.save!
    assert_equal 'Alice', @patient.middle_name
  end

  test 'family name contains extra spaces' do
    @patient.family_name = '  Doe  '

    @patient.save!
    assert_equal 'Doe', @patient.family_name
  end

  test 'family name2 contains extra spaces' do
    @patient.family_name2 = '  Doe  '

    @patient.save!
    assert_equal 'Doe', @patient.family_name2
  end

  test 'identifier contains extra spaces' do
    @patient.identifier = '  12345  '

    @patient.save!
    assert_equal '12345', @patient.identifier
  end

  test 'phone contains extra spaces' do
    @patient.phone = '  555-5555  '

    @patient.save!
    assert_equal '555-5555', @patient.phone
  end

  test 'address contains extra spaces' do
    @patient.address = '  123  Elm  St.  '

    @patient.save!
    assert_equal '123 Elm St.', @patient.address
  end

  test 'policy number contains extra spaces' do
    @patient.policy_number = '  12345  '

    @patient.save!
    assert_equal '12345', @patient.policy_number
  end
end
