# frozen_string_literal: true

module DiagnosticReportStatus
  extend ActiveSupport::Concern

  included do
    include AASM

    # http://hl7.org/fhir/valueset-diagnostic-report-status.html
    enum status: {
      registered:       'registered',
      partial:          'partial',
      preliminary:      'preliminary',
      final:            'final',
      amended:          'amended',
      corrected:        'corrected',
      appended:         'appended',
      cancelled:        'cancelled',
      entered_in_error: 'entered-in-error',
      unknown:          'unknown'
    }

    aasm column: :status, enum: true do
      state :registered, initial: true
      state :partial, :preliminary, :final, :amended, :corrected, :apended, :cancelled

      event :evaluate do
        transitions from: [:registered, :partial, :preliminary], to: :registered, if: :no_values?
        transitions from: [:registered, :partial, :preliminary], to: :preliminary, if: :complete?
        transitions from: [:registered, :partial, :preliminary], to: :partial
        transitions from: [:final, :amended], to: :amended
      end

      event :certify do
        transitions from: [:preliminary], to: :final
        transitions from: [:partial], to: :final # XXX if ...
      end
    end
  end
end
