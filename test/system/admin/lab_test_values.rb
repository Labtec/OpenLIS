# frozen_string_literal: true

require 'application_system_test_case'

module System
  module Admin
    class LabTestValuesTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @lab_test_value = lab_test_values(:positive)
      end

      def teardown
        Warden.test_reset!
      end

      test '#index lab_test_values' do
        visit admin_lab_test_values_path

        assert page.has_content?(@lab_test_value.value)
      end

      test '#create lab_test_value' do
        visit admin_lab_test_values_path
        click_on 'New Lab Test Value'
        fill_in 'Value', with: 'Negative'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Lab Test Value not created'
        assert page.has_content?('Negative')
      end

      test '#update lab_test_value' do
        visit admin_lab_test_values_path
        within id: dom_id(@lab_test_value) do
          click_on 'Edit'
        end
        fill_in 'Value', with: 'Negative'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Lab Test Value not updated'
        assert page.has_content?('Negative')
      end

      test '#delete lab_test_value' do
        visit admin_lab_test_values_path

        assert_selector 'tr', text: @lab_test_value.value

        accept_confirm do
          within id: dom_id(@lab_test_value) do
            click_on 'Destroy'
          end
        end

        assert_no_selector 'tr', text: @lab_test_value.value
      end
    end
  end
end
