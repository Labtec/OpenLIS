# frozen_string_literal: true

module DataAbsentReason
  extend ActiveSupport::Concern

  included do
    # http://hl7.org/fhir/valueset-data-absent-reason.html
    # enum data_absent_reason: {
    #   unknown:           'unknown',
    #   asked_unknown:     'asked-unknown',
    #   temp_unknown:      'temp-unknown',
    #   not_asked:         'not-asked',
    #   asked_declined:    'asked-declined',
    #   masked:            'masked',
    #   not_applicable:    'not-applicable',
    #   unsupported:       'unsupported',
    #   as_text:           'as-text',
    #   error:             'error',
    #   not_a_number:      'not-a-number',
    #   negative_infinity: 'negative-infinity',
    #   positive_infinity: 'positive-infinity',
    #   not_performed:     'not-performed',
    #   not_permitted:     'not-permitted'
    # }

    def not_performed?
      data_absent_reason == 'not-performed'
    end

    def not_performed!
      update_columns(data_absent_reason: 'not-performed') unless value_present?
    end

    def performed?
      data_absent_reason.nil?
    end

    def performed!
      update_columns(data_absent_reason: nil)
    end
  end
end
