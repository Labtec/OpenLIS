# frozen_string_literal: true

module FHIRable
  module CodeableConcept
    extend ActiveSupport::Concern

    def fhirable_codeable_concept(code)
      FHIR::CodeableConcept.new(
        coding: fhirable_codeable_concept_codings(code),
        text: code.value
      )
    end

    private

    def fhirable_codeable_concept_codings(code)
      codings = []

      codings << FHIR::Coding.new(system: "http://loinc.org", code: code.loinc, display: loinc_lookup(code.loinc)) if code.loinc.present?
      codings << FHIR::Coding.new(system: "http://snomed.info/sct", code: code.snomed, display: snomed_lookup(code.snomed)) if code.snomed.present?

      codings
    end
  end
end
