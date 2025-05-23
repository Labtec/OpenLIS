# frozen_string_literal: true

module FHIRable
  module DiagnosticReport
    extend ActiveSupport::Concern
    include Observation
    include Reference

    def fhirable_diagnostic_report
      dr = FHIR::DiagnosticReport.new(
        id:,
        # 'basedOn': fhirable_reference(service_request),
        status:,
        category: fhirable_diagnostic_report_categories,
        # XXX code is mandatory
        # This should be the LOINC code for the panel/observation.
        # If multiple panels/observations were part of the diagnostic report,
        # individual reports shall be issued.  There can only be one code present.
        # 'code': MANDATORY
        subject: fhirable_reference(patient),
        # 'encounter':
        effectiveDateTime: drawn_at.utc.iso8601,
        issued: reported_at&.utc&.iso8601,
        performer: fhirable_diagnostic_report_performers,
        'resultsInterpreter': fhirable_diagnostic_report_results_interpreters,
        specimen: fhirable_reference(self),
        result: fhirable_diagnostic_report_results(results),
        # 'conclusion':
        # 'conclusionCode':
        presentedForm: fhirable_diagnostic_report_presented_form
      )
      dr.resultsInterpreter = [ fhirable_reference(reporter) ] if reporter

      dr
    end

    def to_bundle(base_url)
      bundle = FHIR::Bundle.new(type: "collection")
      patient_url = "#{base_url}/Patient/#{patient.uuid}"
      bundle.entry[0] = FHIR::Bundle::Entry.new(fullUrl: patient_url, resource: FHIR.from_contents(patient.to_json))
      results.each do |result|
        bundle.entry << FHIR::Bundle::Entry.new(
          fullUrl: "#{base_url}/Observation/#{result.id}",
          resource: FHIR.from_contents(result.to_json)
        )
      end
      bundle
    end

    def to_json(_options = {})
      fhirable_diagnostic_report.to_json
    end

    def to_xml(_options = {})
      fhirable_diagnostic_report.to_xml
    end

    private

    def fhirable_diagnostic_report_categories
      categories = []
      departments.uniq.each do |department|
        next if department.code.blank?

        categories << FHIR::CodeableConcept.new(
          coding: [ fhirable_diagnostic_report_categories_codings(department.code) ],
          text: department.name
        )
      end
      categories
    end

    def fhirable_diagnostic_report_categories_codings(code)
      FHIR::Coding.new(system: "http://terminology.hl7.org/CodeSystem/v2-0074", code:)
    end

    def fhirable_diagnostic_report_performers
      # XXX: Use PractitionerRole
      performers = []
      performers << fhirable_reference(drawer) if drawer
      performers << fhirable_reference(receiver) if receiver
      performers << fhirable_reference(reporter) if reporter
      performers.uniq
    end

    def fhirable_diagnostic_report_results_interpreters
      interpreters = []
      interpreters << fhirable_reference(doctor) if doctor
    end

    def fhirable_diagnostic_report_results(results)
      results.map do |result|
        FHIR.from_contents(result.to_json)
      end
    end

    def fhirable_diagnostic_report_presented_form
      nil
    end
  end
end
