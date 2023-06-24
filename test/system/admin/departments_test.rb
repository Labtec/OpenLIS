# frozen_string_literal: true

require 'application_system_test_case'

module System
  module Admin
    class DepartmentsTest < ApplicationSystemTestCase
      def setup
        login_as(users(:admin), scope: :user)
        @department = departments(:chemistry)
      end

      def teardown
        Warden.test_reset!
      end

      test '#index departments' do
        visit admin_departments_path

        assert page.has_content?(@department.name)
      end

      test '#create department' do
        visit admin_departments_path
        click_on '+'
        fill_in 'Name', with: 'Immunology'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Department not created'
        assert page.has_content?('Immunology')
      end

      test '#update department' do
        visit admin_departments_path
        within id: dom_id(@department) do
          click_on @department.name
        end
        click_on 'Edit'
        fill_in 'Name', with: 'Immunology'
        click_on 'Submit'

        assert_not page.has_content?('error'), 'Department not updated'
        assert page.has_content?('Immunology')
      end
    end
  end
end
