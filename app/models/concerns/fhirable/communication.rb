# frozen_string_literal: true

module FHIRable
  module Communication
    extend ActiveSupport::Concern

    def fhirable_communication
      [
        {
          language: {
            coding: [
              {
                system: "http://hl7.org/fhir/ValueSet/languages",
                code: "es",
                display: "Spanish"
              }
            ],
            text: "Spanish"
          },
          preferred: true
        }
      ]
    end
  end
end
