# frozen_string_literal: true

require "application_system_test_case"

module System
  class AccessionsTest < ApplicationSystemTestCase
    def setup
      login_as(users(:user), scope: :user)
      @patient = patients(:john)
    end

    def teardown
      Warden.test_reset!
    end

    test "create new order from panel" do
      visit patient_path(@patient)
      within(".title_tools") { click_on "Order Tests" }
      within("#order_tests") { click_on "Chemistry" }

      assert page.has_unchecked_field?("BUN")
      assert page.has_unchecked_field?("Cholesterol")

      check "Panel"

      assert page.has_field?("BUN", disabled: true), "BUN is not disabled"
      assert page.has_field?("Cholesterol", disabled: true), "CHOL is not disabled"

      click_on "Save"

      assert_not page.has_content?("error"), "Requisition not created"
      assert page.has_content?("Successfully created requisition")

      assert page.has_content?("BUN")
      assert page.has_content?("Cholesterol")
    end

    test "edit a paneled order" do
      accession = accessions(:paneled)
      visit edit_accession_path(accession)

      assert page.has_checked_field?("Panel"), "Panel is not checked"

      within("#order_tests") { click_on "Chemistry" }
      assert page.has_field?("BUN", disabled: true), "BUN is not disabled"
      assert page.has_field?("Cholesterol", disabled: true), "CHOL is not disabled"

      uncheck "Panel"

      assert page.has_checked_field?("BUN"), "BUN is not checked"
      assert page.has_checked_field?("Cholesterol"), "CHOL is not checked"

      click_on "Save"

      assert_not page.has_content?("error"), "Requisition not created"
      assert page.has_content?("Successfully updated requisition")

      assert page.has_content?("BUN")
      assert page.has_content?("Cholesterol")
    end
  end
end
