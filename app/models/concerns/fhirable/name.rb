# frozen_string_literal: true

module FHIRable
  module Name
    extend ActiveSupport::Concern

    def fhirable_name
      [
        {
          use: animal_type.present? ? "usual" : "official",
          family: family_name || partner_name,
          given: [
            given_name,
            middle_name
          ]
        }
      ]
    end

    def fhirable_practitioner_name
      [
        {
          use: "usual",
          text: name,
          prefix: practitioner_prefix
        }
      ]
    end

    private

    def practitioner_prefix
      return if organization?

      if gender == "female"
        "Dra."
      else
        "Dr."
      end
    end
  end
end
