# frozen_string_literal: true

require 'application_system_test_case'

module System
  module Admin
    class QualifiedValuesTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @qualified_value = qualified_values(:ldl)
      end

      def teardown
        Warden.test_reset!
      end

      test '#index qualified_values' do
        visit admin_qualified_values_path

        assert page.has_content?(@qualified_value.lab_test.name)
      end

      test '#create qualified_value' do
        visit admin_qualified_values_path
        click_on 'New Qualified Value'
        select 'BUN', from: 'Lab test'
        within '.range' do
          fill_in 'Low', with: 6
          fill_in 'High', with: 24
        end
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Qualified Value not created'
        assert page.has_content?('BUN')
      end

      test '#update qualified_value' do
        visit admin_qualified_values_path
        within id: dom_id(@qualified_value) do
          click_on 'Edit'
        end
        select 'BUN', from: 'Lab test'
        within '.range' do
          fill_in 'Low', with: 6
          fill_in 'High', with: 24
        end
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Qualified Value not updated'
        assert page.has_content?('BUN')
      end

      test '#delete qualified_value' do
        visit admin_qualified_values_path
        within id: dom_id(@qualified_value) do
          click_on 'Edit'
        end
        within '.range' do
          fill_in 'Low', with: 123_456_789
          fill_in 'High', with: 987_654_321
        end
        click_on 'Submit'

        assert_selector 'tr', text: '123,456,789–987,654,321'

        accept_confirm do
          within id: dom_id(@qualified_value) do
            click_on 'Delete'
          end
        end

        assert_no_selector 'tr', text: '123,456,789–987,654,321'
      end
    end
  end
end
