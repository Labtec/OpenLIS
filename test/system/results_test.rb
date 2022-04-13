# frozen_string_literal: true

require 'application_system_test_case'

module System
  class ResultsTest < ApplicationSystemTestCase
    def setup
      login_as(users(:user), scope: :user)
      @observation = observations(:observation)
    end

    def teardown
      Warden.test_reset!
    end

    test 'display formatted values' do
      @observation.update(lab_test: lab_tests(:qualitative),
                          lab_test_value: lab_test_values(:html))

      visit diagnostic_report_url(@observation.accession)

      assert_not page.has_content?('<i>E. coli</i>')
      assert page.has_css?('i', text: 'E. coli')
    end
  end
end
