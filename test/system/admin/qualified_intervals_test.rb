# frozen_string_literal: true

require "application_system_test_case"

module System
  module Admin
    class QualifiedIntervalsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @qualified_interval = qualified_intervals(:ldl)
      end

      def teardown
        Warden.test_reset!
      end

      test "#index qualified_intervals" do
        visit admin_qualified_intervals_path

        assert page.has_content?(@qualified_interval.lab_test.name)
      end

      test "#create qualified_interval" do
        visit admin_qualified_intervals_path
        click_on "New Qualified Interval"
        select "BUN", from: "Lab test"
        within ".range" do
          fill_in "Low", with: 6
          fill_in "High", with: 24
        end
        click_on "Submit"

        assert_not page.has_content?("error"), "Qualified Interval not created"
        assert page.has_content?("BUN")
      end

      test "#update qualified_interval" do
        visit admin_qualified_intervals_path
        within id: dom_id(@qualified_interval) do
          click_on "Edit"
        end
        select "BUN", from: "Lab test"
        within ".range" do
          fill_in "Low", with: 6
          fill_in "High", with: 24
        end
        click_on "Submit"

        assert_not page.has_content?("error"), "Qualified Interval not updated"
        assert page.has_content?("BUN")
      end

      test "#delete qualified_interval" do
        visit admin_qualified_intervals_path
        within id: dom_id(@qualified_interval) do
          click_on "Edit"
        end
        within ".range" do
          fill_in "Low", with: 123_456_789
          fill_in "High", with: 987_654_321
        end
        click_on "Submit"

        assert_selector "tr", text: "123,456,789–987,654,321"

        accept_confirm do
          within id: dom_id(@qualified_interval) do
            click_on "Delete"
          end
        end

        assert_no_selector "tr", text: "123,456,789–987,654,321"
      end
    end
  end
end
