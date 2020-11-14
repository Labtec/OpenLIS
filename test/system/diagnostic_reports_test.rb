# frozen_string_literal: true

require 'application_system_test_case'

class DiagnosticReportsTest < ApplicationSystemTestCase
  def setup
    login_as(users(:user), scope: :user)
    @service_request = accessions(:lipid)
  end

  def teardown
    Warden.test_reset!
    filename = "resultados_#{@service_request.id}.pdf"
    File.delete(filename) if File.exist?(filename)
  end

  test "diagnostic report's state machine" do
    diagnostic_report = Accession.find(@service_request.id)
    visit diagnostic_report_url(diagnostic_report)

    assert page.has_content?('LDL/HDL Ratio')
    assert page.has_content?('Cholesterol in LDL')
    assert page.has_content?('Triglyceride')
    assert page.has_content?('Cholesterol in HDL')
    assert page.has_content?('Cholesterol')
    assert page.has_content?('calc.')
    assert page.has_content?('pend.')
    assert Accession.find(@service_request.id).registered?, 'Not Registered'

    click_on 'Enter Results'

    fill_in 'Cholesterol', with: 200
    fill_in 'Cholesterol in HDL', with: 100
    fill_in 'Triglyceride', with: 110

    click_on 'Save Results'

    visit diagnostic_report_url(diagnostic_report)
    assert_not page.has_content?('calc.')
    assert_not page.has_content?('pend.')
    assert Accession.find(@service_request.id).preliminary?, 'Not Preliminary'

    click_on 'Certify'
    visit diagnostic_report_url(diagnostic_report)
    assert Accession.find(@service_request.id).final?, 'Not Final'

    click_on 'Change Results'

    fill_in 'Cholesterol in HDL', with: 150
    click_on 'Save Results'
    visit diagnostic_report_url(diagnostic_report)
    assert Accession.find(@service_request.id).amended?, 'Not Amended'
  end

  test 'force certifying a report' do
    login_as(users(:admin), scope: :user)
    diagnostic_report = Accession.find(@service_request.id)
    visit diagnostic_report_url(diagnostic_report)

    assert page.has_content?('LDL/HDL Ratio')
    assert page.has_content?('Cholesterol in LDL')
    assert page.has_content?('Triglyceride')
    assert page.has_content?('Cholesterol in HDL')
    assert page.has_content?('Cholesterol')
    assert page.has_content?('calc.')
    assert page.has_content?('pend.')
    assert Accession.find(@service_request.id).registered?, 'Not Registered'

    click_on 'Enter Results'

    fill_in 'Cholesterol', with: 200
    fill_in 'Cholesterol in HDL', with: 100
    click_on 'Save Results'
    click_on 'Force Certify'

    wait = Selenium::WebDriver::Wait.new(ignore: Selenium::WebDriver::Error::NoSuchAlertError)
    alert = wait.until { page.driver.browser.switch_to.alert }
    alert.accept

    assert page.has_content?('calc.')
    assert page.has_content?('pend.')
    assert Accession.find(@service_request.id).final?, 'Not Final'
    trig = Accession.find(@service_request.id).results.joins(:lab_test).where('lab_tests.code': 'TRIG').take
    assert trig.cancelled?, 'Triglyceride Not Cancelled'
    assert trig.not_performed?, 'Triglyceride Performed'
  end
end
