# frozen_string_literal: true

require 'application_system_test_case'

module System
  module Admin
    class LabTestsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @lab_test = lab_tests(:multiple_intervals_nil_min_interval)
      end

      def teardown
        Warden.test_reset!
      end

      test '#index lab_tests' do
        visit admin_lab_tests_path

        assert page.has_content?(@lab_test.name)
      end

      test '#create lab_test' do
        visit admin_lab_tests_path
        click_on 'New Lab Test'
        fill_in 'Code', with: 'COVID19'
        fill_in 'Name', with: 'SARS-CoV-2'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'LabTest not created'
        assert page.has_content?('SARS-CoV-2')
      end

      test '#update lab_test' do
        visit admin_lab_tests_path
        within id: dom_id(@lab_test) do
          click_on 'Edit'
        end
        fill_in 'Code', with: 'COVID19'
        fill_in 'Name', with: 'SARS-CoV-2'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Lab Test not updated'
        assert page.has_content?('SARS-CoV-2')
      end

      test '#delete lab_test' do
        visit admin_lab_tests_path

        assert_text @lab_test.code

        accept_confirm do
          within id: dom_id(@lab_test) do
            click_on 'Delete'
          end
        end

        assert_no_text @lab_test.code
      end
    end
  end
end
