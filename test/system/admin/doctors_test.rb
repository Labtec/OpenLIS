# frozen_string_literal: true

require "application_system_test_case"

module System
  module Admin
    class DoctorsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @doctor = doctors(:doctor)
      end

      def teardown
        Warden.test_reset!
      end

      test "#index doctors" do
        visit admin_doctors_path

        assert page.has_content?(@doctor.name)
      end

      test "#create doctor" do
        visit admin_doctors_path
        click_on "New Doctor"
        fill_in "Name", with: "Sbaitso"
        fill_in "Email", with: "sbaitso@creative.example.com"
        click_on "Submit"

        assert_not page.has_content?("error"), "Doctor not created"
        assert page.has_content?("Sbaitso")
      end

      test "#update doctor" do
        visit admin_doctors_path
        within id: dom_id(@doctor) do
          click_on "Edit"
        end
        fill_in "Name", with: "Sbaitso"
        fill_in "Email", with: "sbaitso@creative.example.com"
        click_on "Submit"

        assert_not page.has_content?("error"), "Doctor not updated"
        assert page.has_content?("Sbaitso")
      end

      test "#delete doctor" do
        visit admin_doctors_path

        assert_selector "tr", text: @doctor.name

        accept_confirm do
          within id: dom_id(@doctor) do
            click_on "Delete"
          end
        end

        assert_no_selector "tr", text: @doctor.name
      end
    end
  end
end
