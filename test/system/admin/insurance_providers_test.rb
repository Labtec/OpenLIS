# frozen_string_literal: true

require "application_system_test_case"

module System
  module Admin
    class InsuranceProvidersTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @insurance_provider = insurance_providers(:axa)
      end

      def teardown
        Warden.test_reset!
      end

      test "#index insurance_providers" do
        visit admin_insurance_providers_path

        assert page.has_content?(@insurance_provider.name)
      end

      test "#create insurance_provider" do
        visit admin_insurance_providers_path
        click_on "New Insurance Provider"
        fill_in "Name", with: "UNH"
        select "Price List", from: "Price list"
        click_on "Submit"

        assert_not page.has_content?("error"), "Insurance Provider not created"
        assert page.has_content?("UNH")
      end

      test "#update insurance_provider" do
        visit admin_insurance_providers_path
        within id: dom_id(@insurance_provider) do
          click_on "Edit"
        end
        fill_in "Name", with: "UNH"
        click_on "Submit"

        assert_not page.has_content?("error"), "Insurance Provider not updated"
        assert page.has_content?("UNH")
      end
    end
  end
end
