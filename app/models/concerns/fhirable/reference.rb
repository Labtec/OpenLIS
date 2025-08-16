# frozen_string_literal: true

module FHIRable
  module Reference
    extend ActiveSupport::Concern

    def fhirable_reference(reference)
      FHIR::Reference.new(
        reference: fhirable_reference_reference(reference)
      )
    end

    private

    def fhirable_reference_reference(reference)
      case reference
      when *Accession
        "Specimen/#{reference.id}"
      when *Doctor, *User
        "Practitioner/#{reference.uuid}"
      when *Patient
        "Patient/#{reference.uuid}"
      end
    end
  end
end
