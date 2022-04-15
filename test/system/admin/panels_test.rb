# frozen_string_literal: true

require 'application_system_test_case'

module System
  module Admin
    class PanelsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @panel = panels(:panel)
      end

      def teardown
        Warden.test_reset!
      end

      test '#index panels' do
        visit admin_panels_path

        assert page.has_content?(@panel.name)
      end

      test '#create panel' do
        visit admin_panels_path
        click_on 'New Panel'
        fill_in 'Code', with: 'LIPID'
        fill_in 'Name', with: 'Lipid Panel'
        check 'Cholesterol'
        check 'Cholesterol in HDL'
        check 'Cholesterol in LDL'
        check 'LDL/HDL Ratio'
        check 'Triglyceride'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Panel not created'
        assert page.has_content?('Lipid Panel')
      end

      test '#update panel' do
        visit admin_panels_path
        within id: dom_id(@panel) do
          click_on 'Edit'
        end
        fill_in 'Code', with: 'LIPID'
        fill_in 'Name', with: 'Lipid Panel'
        uncheck 'BUN'
        check 'Cholesterol'
        check 'Cholesterol in HDL'
        check 'Cholesterol in LDL'
        check 'LDL/HDL Ratio'
        check 'Triglyceride'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Panel not updated'
        assert page.has_content?('Lipid Panel')
      end

      test '#delete panel' do
        visit admin_panels_path

        assert_selector 'tr', text: @panel.name

        accept_confirm do
          within id: dom_id(@panel) do
            click_on 'Destroy'
          end
        end

        assert_no_selector 'tr', text: @panel.name
      end
    end
  end
end
