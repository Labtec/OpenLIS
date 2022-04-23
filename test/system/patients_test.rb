# frozen_string_literal: true

require 'application_system_test_case'

module System
  class PatientsTest < ApplicationSystemTestCase
    def setup
      login_as(users(:user), scope: :user)
      @patient = patients(:john)
    end

    def teardown
      Warden.test_reset!
    end

    test '#index patients' do
      visit patients_path

      assert page.has_content?(@patient.given_name)
    end

    test '#create patient' do
      visit patients_path
      within('.title_tools') { click_on 'New Patient' }
      fill_in 'Given name', with: 'Amber'
      fill_in 'Last name', with: 'Zigbee'
      select 'Female', from: 'Sex'
      select_date 25.years.ago, from: 'patient_birthdate'
      click_on 'Save Patient'

      assert_not page.has_content?('error'), 'New patient not added'
      assert page.has_content?('Amber Zigbee')
    end

    test '#create patient with address' do
      visit patients_path
      within('.title_tools') { click_on 'New Patient' }
      fill_in 'Given name', with: 'Amber'
      fill_in 'Last name', with: 'Zigbee'
      select 'Female', from: 'Sex'
      select_date 25.years.ago, from: 'patient_birthdate'

      assert page.has_field?('District', disabled: true), 'District is not disabled'
      assert page.has_field?('Corregimiento', disabled: true), 'Corregimiento is not disabled'
      assert page.has_field?('Line', disabled: true), 'Line is not disabled'

      select 'Panamá', from: 'Province'
      select 'Panamá', from: 'District'
      select 'Ancón', from: 'Corregimiento'
      fill_in 'Line', with: 'Balboa'

      click_on 'Save Patient'

      assert_not page.has_content?('error'), 'New patient not added'
      assert page.has_content?('Amber Zigbee')
    end

    test '#update patient' do
      visit patients_path
      find("##{dom_id(@patient)}").hover
      click_on 'Edit'
      fill_in 'Given name', with: 'Amber'
      fill_in 'Middle name', with: ''
      fill_in 'Last name', with: 'Zigbee'
      select 'Female', from: 'Sex'
      select_date 25.years.ago, from: 'patient_birthdate'
      click_on 'Save Patient'

      assert_not page.has_content?('error'), 'Patient not updated'
      assert page.has_content?('Amber Zigbee')
    end

    test 'user can not #delete patient' do
      skip
      visit patients_path

      assert_selector '.list', text: @patient.given_name

      find("##{dom_id(@patient)}").hover

      assert page.has_link?('Edit')
      assert_not page.has_button?('Delete?')
    end

    test '#delete patient' do
      login_as(users(:admin), scope: :user)
      visit patients_path

      assert_selector '.list', text: @patient.given_name

      accept_confirm do
        find("##{dom_id(@patient)}").hover
        click_on 'Delete?'
      end

      assert_no_selector '.list', text: @patient.given_name
    end

    test '#search patient' do
      visit root_path
      fill_in 'Search patients', with: "Alicia Doe\n"

      assert_not page.has_content?('222-222-2222'), 'Non-searched patient'
      assert page.has_content?('111-111-1111'), 'Patient search failed'
    end
  end
end
