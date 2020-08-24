# frozen_string_literal: true

require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  ANIMAL_SPECIES = (0..3).to_a
  GENDERS = %w[F M O U].freeze

  test 'presence of birthdate' do
    patient = Patient.create(birthdate: '')
    assert patient.errors.added?(:birthdate, :blank)
  end

  test 'presence of family name unless partner name present' do
    patient = Patient.create(family_name: '', partner_name: '')
    assert patient.errors.added?(:family_name, :blank)

    patient = Patient.create(family_name: '', partner_name: 'Doe')
    assert_not patient.errors.added?(:family_name, :blank)
  end

  test 'presence of given name' do
    patient = Patient.create(given_name: '')
    assert patient.errors.added?(:given_name, :blank)
  end

  test 'presence of partner name unless family name present' do
    patient = Patient.create(partner_name: '', family_name: '')
    assert patient.errors.added?(:partner_name, :blank)

    patient = Patient.create(partner_name: '', family_name: 'Doe')
    assert_not patient.errors.added?(:partner_name, :blank)
  end

  test 'uniqueness of identifier ignoring case sentitivity allowing blank' do
    patient = Patient.create(identifier: '111-111-1111')
    assert patient.errors.added?(:identifier, :taken, value: '111-111-1111')

    patient = Patient.create(identifier: 'ins-1')
    assert patient.errors.added?(:identifier, :taken, value: 'ins-1')

    patient = Patient.create(identifier: '')
    assert_not patient.errors.added?(:identifier, :blank)
  end

  test 'length of family name' do
    patient = Patient.create(family_name: 'D')
    assert patient.errors.added?(:family_name, :too_short, count: 2)
  end

  test 'length of given name' do
    patient = Patient.create(given_name: 'J')
    assert patient.errors.added?(:given_name, :too_short, count: 2)
  end

  test 'length of partner name' do
    patient = Patient.create(partner_name: 'D')
    assert patient.errors.added?(:partner_name, :too_short, count: 2)
  end

  test 'inclusion of animal type in ANIMAL_SPECIES allowing blank' do
    assert_equal Patient.validators_on(:animal_type).map(&:options),
                 [{ allow_blank: true, in: ANIMAL_SPECIES }]
  end

  test 'inclusion of gender in GENDERS' do
    assert_equal Patient.validators_on(:gender).map(&:options),
                 [{ in: GENDERS }]
  end

  test 'birthdate is not in the future' do
    p = patients(:john)

    p.birthdate = 1.day.from_now
    assert p.invalid?, 'A patient born tomorrow should not be valid'

    p.birthdate = Date.current
    assert p.valid?, 'A patient born today should be valid'
  end

  test "no family name and partner's name" do
    p = patients(:john)

    p.family_name = nil
    assert p.invalid?, "A patient must have a family name or a partner's name"

    p.partner_name = 'Doe'
    assert p.valid?, "A patient with only a partner's name should be valid"
  end
end
