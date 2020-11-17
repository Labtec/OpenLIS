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
      if reference.is_a? Accession
        "Specimen/#{reference.id}"
      elsif reference.is_a? Patient
        "Patient/#{reference.id}"
      elsif reference.is_a? User
        "Practitioner/#{reference.id}"
      end
    end
  end
end
