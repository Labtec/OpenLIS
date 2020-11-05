# frozen_string_literal: true

require 'test_helper'

class ResultsTest < ActionDispatch::IntegrationTest
  def setup
    login_as(users(:user), scope: :user)
    @patient = patients(:john)
    @accession = @patient.accessions.create!(
      drawn_at: Time.current,
      received_at: Time.current,
      drawer: users(:user),
      receiver: users(:user),
      lab_test_ids: [lab_tests(:range).id]
    )
  end

  def teardown
    Warden.test_reset!
  end

  test 'wrong result format' do
    visit edit_diagnostic_report_path(@accession)

    fill_in 'Range', with: '1:2'
    click_on 'Save'
    assert page.has_content?('error'), 'Wrong format not validated'
  end

  test 'valid resul format' do
    visit edit_diagnostic_report_path(@accession)

    fill_in 'Range', with: '1-2'
    click_on 'Save'
    assert page.has_content?('Successfully updated results')
  end
end
