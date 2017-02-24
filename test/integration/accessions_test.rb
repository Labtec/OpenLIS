require 'test_helper'

class AccessionsTest < ActionDispatch::IntegrationTest
  def setup
    login_as(users(:user), scope: :user)
    @patient = patients(:john)
    @accession = @patient.accessions.create!(
      drawn_at: Time.current,
      received_at: Time.current,
      drawer: users(:user),
      receiver: users(:user),
      lab_test_ids: [lab_tests(:bun).id, lab_tests(:chol).id]
    )
  end

  def teardown
    Warden.test_reset!
  end

  test 'create a new requisition' do
    visit patient_path(@patient)
    within('.title_tools') { click_on 'Order Tests' }
    check 'BUN'
    click_on 'Save'
    assert_not page.has_content?('error'), 'Requisition not created'
    assert page.has_content?('Successfully created requisition')
    assert page.has_content? users(:user).initials
  end

  test 'an empty requisition' do
    visit patient_path(@patient)
    within('.title_tools') { click_on 'Order Tests' }
    click_on 'Save'
    assert page.has_content?('error'), 'Requisition can not be empty'
  end

  test 'change a requisition' do
    visit edit_accession_path(@accession)
    assert page.has_content?("Accession ##{@accession.id}"), 'Order number missing'
    uncheck 'BUN'
    click_on 'Save'
    assert_not page.has_content?('error'), 'Requisition not updated'
    assert page.has_content?('Successfully updated requisition')
  end

  test 'clear a requisition' do
    visit edit_accession_path(@accession)
    uncheck 'BUN'
    uncheck 'Cholesterol'
    click_on 'Save'
    assert page.has_content?('error'), 'Requisition can not be empty'
  end

  test 'enter test results' do
    visit edit_results_accession_path(@accession)
    assert page.has_content?("Accession ##{@accession.id}"), 'Order number missing'
    fill_in 'Cholesterol', with: 180
    click_on 'Save'
    assert_not page.has_content?('error'), 'Results not entered'
    assert page.has_content?('Successfully updated requisition')
  end
end
