# frozen_string_literal: true

module FHIRable
  module Identifier
    extend ActiveSupport::Concern

    # TODO: Implement an identifier type ['NNPAN', 'PPN']
    def fhirable_identifier
      return unless identifier.present?

      [
        {
          'use': 'official',
          'type': {
            'coding': [
              'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
              'code': 'NNPAN'
            ]
          },
          'system': 'https://sede.tribunal-electoral.gob.pa/sede-cedula-web',
          'value': identifier
        },
        fhirable_identifier_member_number
      ]
    end

    private

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
