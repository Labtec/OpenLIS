# frozen_string_literal: true

module DiagnosticReportStatus
  extend ActiveSupport::Concern

  included do
    include AASM

    # http://hl7.org/fhir/valueset-diagnostic-report-status.html
    attribute :status, :string
    enum :status, {
      registered: "registered",
      partial: "partial",
      preliminary: "preliminary",
      final: "final",
      amended: "amended",
      corrected: "corrected",
      appended: "appended",
      cancelled: "cancelled",
      entered_in_error: "entered-in-error",
      unknown: "unknown"
    }

    aasm column: :status, enum: true do
      state :registered, initial: true
      state :partial, :preliminary, :final, :amended, :corrected, :appended, :cancelled

      event :evaluate do
        transitions from: [ :registered, :partial, :preliminary ], to: :registered, if: :no_values?
        transitions from: [ :registered, :partial, :preliminary ], to: :preliminary, if: :complete?
        transitions from: [ :registered, :partial, :preliminary ], to: :partial
        transitions from: [ :final ], to: :amended, if: :changed?
        transitions from: [ :final ], to: :amended, if: :results_changed?
        transitions from: [ :final ], to: :final
        transitions from: [ :amended ], to: :amended
      end

      event :certify do
        transitions from: [ :preliminary ], to: :final
        transitions from: [ :final ], to: :final
        transitions from: [ :amended ], to: :amended
      end

      event :force_certify do
        transitions from: [ :partial, :preliminary ], to: :final
        transitions from: [ :final ], to: :final
        transitions from: [ :amended ], to: :amended
      end
    end
  end
end
