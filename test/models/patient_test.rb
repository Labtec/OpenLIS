require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  ANIMAL_TYPES = (0..3).to_a.freeze
  GENDERS = %w(F M U).freeze

  should validate_inclusion_of(:animal_type).in_array(ANIMAL_TYPES).allow_blank
  should validate_inclusion_of(:gender).in_array(GENDERS)
  should validate_presence_of(:given_name)
  should validate_presence_of(:family_name)
  should validate_presence_of(:birthdate)
  should validate_length_of(:given_name).is_at_least(2)
  should validate_length_of(:family_name).is_at_least(2)
  should validate_uniqueness_of(:identifier).
    ignoring_case_sensitivity.
    allow_blank

  test 'birthdate is not in the future' do
    p = patients(:john)

    p.birthdate = Date.tomorrow
    assert p.invalid?, 'A patient born tomorrow should not be valid'

    p.birthdate = Date.current
    assert p.valid?, 'A patient born today should be valid'
  end
end
