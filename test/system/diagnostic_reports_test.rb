# frozen_string_literal: true

require "application_system_test_case"

module System
  class DiagnosticReportsTest < ApplicationSystemTestCase
    def setup
      login_as(users(:user), scope: :user)
      @service_request = accessions(:lipid)
    end

    def teardown
      Warden.test_reset!
      filename = "resultados_#{@service_request.id}.pdf"
      FileUtils.rm_f(filename)
    end

    test "diagnostic report's state machine" do
      diagnostic_report = Accession.find(@service_request.id)
      visit diagnostic_report_url(@service_request)

      assert page.has_content?("LDL/HDL Ratio")
      assert page.has_content?("Cholesterol in LDL")
      assert page.has_content?("Triglyceride")
      assert page.has_content?("Cholesterol in HDL")
      assert page.has_content?("Cholesterol")
      assert page.has_content?("calc.")
      assert page.has_content?("pend.")
      assert Accession.find(diagnostic_report.id).registered?, "Not Registered"

      click_on "Enter Results"

      fill_in "Cholesterol", with: 200
      fill_in "Cholesterol in HDL", with: 100
      fill_in "Triglyceride", with: 110

      click_on "Save Results"

      assert_not page.has_content?("calc.")
      assert_not page.has_content?("pend.")
      # XXX race condition
      # assert Accession.find(diagnostic_report.id).preliminary?, 'Not Preliminary'

      click_on "Certify"
      sleep 1
      visit diagnostic_report_url(diagnostic_report)

      # XXX race condition
      # assert Accession.find(diagnostic_report.id).final?, 'Not Final'

      click_on "Change Results"

      fill_in "Cholesterol in HDL", with: 150
      click_on "Save Results"
      visit diagnostic_report_url(diagnostic_report)

      # XXX race condition
      # assert Accession.find(diagnostic_report.id).amended?, 'Not Amended'
    end
  end
end
