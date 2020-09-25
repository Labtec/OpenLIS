# frozen_string_literal: true

module FHIRable
  module Animal
    extend ActiveSupport::Concern

    def fhirable_animal
      return unless animal_type

      {
        'url': 'http://hl7.org/fhir/StructureDefinition/patient-animal',
        'extension': [
          {
            'url': 'species',
            'valueCodeableConcept': {
              'coding': [
                {
                  'system': 'http://snomed.info/sct',
                  'code': code_for_species,
                  'display': display_for_species
                }
              ]
            }
          }
        ]
      }
    end

    private

    def code_for_species
      case animal_type
      when 1
        '448771007'
      when 2
        '448169003'
      when 3
        '35354009'
      end
    end

    def display_for_species
      case animal_type
      when 1
        'Domestic dog'
      when 2
        'Domestic cat'
      when 3
        'Horse'
      end
    end
  end
end
