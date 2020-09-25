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
                  'system': 'http://hl7.org/fhir/animal-species',
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
        'canislf'
      when 2
        'felisc'
      when 3
        'equusc'
      end
    end

    def display_for_species
      case animal_type
      when 1
        'Dog'
      when 2
        'Cat'
      when 3
        'Horse'
      end
    end
  end
end
