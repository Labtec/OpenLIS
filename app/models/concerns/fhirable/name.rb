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
  end
end
