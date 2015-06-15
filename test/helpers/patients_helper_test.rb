require 'test_helper'

class PatientsHelperTest < ActionView::TestCase
  include PatientsHelper

  setup do
    @patient = create(:patient, given_name: 'John', middle_name: 'Fitzgerald',
                                family_name: 'Doe', family_name2: 'Rockefeller')
  end

  test 'display full name' do
    assert_equal 'John Fitzgerald Doe Rockefeller', full_name(@patient)
  end

  test 'display name as last name comma first name without middle initial' do
    @patient.update(middle_name: '')
    assert_equal 'Doe, John', name_last_comma_first_mi(@patient)
  end

  test 'display name as last name comma first name with a middle initial' do
    assert_equal 'Doe, John F.', name_last_comma_first_mi(@patient)
  end

  test 'if last name starts with a lowercase, uppercase when Last, First' do
    @patient.update(family_name: 'ñel Tomasso')
    assert_equal 'Ñel Tomasso, John F.', name_last_comma_first_mi(@patient)
  end

  test '#animal_type_name' do
    animal_types = { other: 0, canine: 1, feline: 2, equine: 3 }
    animal_types.each do |k, v|
      assert_equal t("patients.#{k}"), animal_type_name(v)
    end
  end
end
