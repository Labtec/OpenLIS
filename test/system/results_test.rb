# frozen_string_literal: true

require 'application_system_test_case'

class ResultsTest < ApplicationSystemTestCase
  def setup
    login_as(users(:user), scope: :user)
    @result = results(:result)
  end

  def teardown
    Warden.test_reset!
  end

  test 'display formatted results' do
    @result.update(lab_test: lab_tests(:qualitative),
                   lab_test_value: lab_test_values(:html))

    visit accession_url(@result.accession)

    assert_not page.has_content?('<i>E. coli</i>')
    assert page.has_content?('E. coli')
  end
end
