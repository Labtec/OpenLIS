# frozen_string_literal: true

require 'application_system_test_case'

class PatientsTest < ApplicationSystemTestCase
  def setup
    login_as(users(:user), scope: :user)
  end

  def teardown
    Warden.test_reset!
  end

  test 'create new patient' do
    visit new_patient_url
    fill_in 'Given name', with: 'Amber'
    fill_in 'Last name', with: 'Zigbee'
    select 'Female', from: 'Sex'
    select_date 25.years.ago, from: 'patient_birthdate'
    click_on 'Save Patient'

    assert_not page.has_content?('error'), 'New patient not added'
    assert page.has_content?('Amber Zigbee')
  end

  test 'search for a patient' do
    visit root_path
    fill_in 'Search patients', with: "Alicia Doe\n"

    assert_not page.has_content?('222-222-2222'), 'Non-searched patient'
    assert page.has_content?('111-111-1111'), 'Patient search failed'
  end
end
