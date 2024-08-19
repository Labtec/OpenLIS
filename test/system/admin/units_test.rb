# frozen_string_literal: true

require "application_system_test_case"

module System
  module Admin
    class UnitsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @unit = units(:unit_a)
      end

      def teardown
        Warden.test_reset!
      end

      test "#index units" do
        visit admin_units_path

        assert page.has_content?(@unit.expression)
      end

      test "#create unit" do
        visit admin_units_path
        click_on "New Unit"
        fill_in "Expression", with: "Hz"
        fill_in "UCUM", with: "Hz"
        click_on "Submit"

        assert_not page.has_content?("error"), "Unit not created"
        assert page.has_content?("Hz")
      end

      test "#update unit" do
        visit admin_units_path
        within id: dom_id(@unit) do
          click_on "Edit"
        end
        fill_in "Expression", with: "Hz"
        fill_in "UCUM", with: "Hz"
        click_on "Submit"

        assert_not page.has_content?("error"), "Unit not updated"
        assert page.has_content?("Hz")
      end
    end
  end
end
