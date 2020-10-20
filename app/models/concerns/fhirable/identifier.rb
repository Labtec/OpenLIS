# frozen_string_literal: true

module FHIRable
  module Identifier
    extend ActiveSupport::Concern

    def fhirable_observation_identifier
      [
        {
          'use': 'official',
          'system': self.to_gid,
          'value': id
        }
      ]
    end

    # TODO: Implement an identifier type ['NNPAN', 'PPN']
    def fhirable_patient_identifier
      return if identifier.blank?

      [
        {
          'use': 'official',
          'type': {
            'coding': [
              'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
              'code': fhirable_identifier_code
            ]
          },
          'system': fhirable_identifier_system,
          'value': identifier
        },
        fhirable_identifier_member_number
      ]
    end

    private

    def fhirable_identifier_code
      identifier_type == 1 ? 'NNPAN' : 'PPN'
    end

    def fhirable_identifier_system
      'https://sede.tribunal-electoral.gob.pa/sede-cedula-web' if identifier_type == 1
    end

    def fhirable_identifier_member_number
      return if policy_number.blank?

      {
        'type': {
          'coding': [
            'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
            'code': 'MB'
          ]
        },
        'system': 'https://www.axa-assistance.com.pa',
        'value': policy_number
      }
    end
  end
end
