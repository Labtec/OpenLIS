# frozen_string_literal: true

module FHIRable
  module Identifier
    extend ActiveSupport::Concern

    # TODO: Implement an identifier type ['NNPAN', 'PPN']
    def fhirable_identifier
      return unless identifier

      [
        {
          'use': 'official',
          'type': {
            'coding': [
              'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
              'code': 'NNPAN'
            ]
          },
          'system': 'https://verificate.pa/cedula?search=',
          'value': identifier
        }
      ]
    end
  end
end
