# frozen_string_literal: true

require "test_helper"

class PatientsTest < ActionDispatch::IntegrationTest
  def setup
    login_as(users(:user), scope: :user)
  end

  def teardown
    Warden.test_reset!
  end

  test "add a new patient" do
    visit new_patient_path
    fill_in "Given name", with: "Amber"
    fill_in "Last name", with: "Zigbee"
    select "Female", from: "Sex"
    select_date 25.years.ago, from: "patient_birthdate"
    click_on "Save Patient"
    assert_not page.has_content?("error"), "New patient not added"
    assert page.has_content?("Amber Zigbee")
  end
end
