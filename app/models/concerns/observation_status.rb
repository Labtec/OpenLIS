# frozen_string_literal: true

module ObservationStatus
  extend ActiveSupport::Concern

  included do
    include AASM

    # http://hl7.org/fhir/valueset-observation-status.html
    enum status: {
      registered:       "registered",
      preliminary:      "preliminary",
      final:            "final",
      amended:          "amended",
      corrected:        "corrected",
      cancelled:        "cancelled",
      entered_in_error: "entered-in-error",
      unknown:          "unknown"
    }

    aasm column: :status, enum: true do
      state :registered, initial: true
      state :preliminary, :final, :amended, :corrected, :cancelled, :entered_in_error, :unknown

      event :evaluate do
        transitions from: [ :registered, :preliminary ], to: :registered, unless: :value_present?
        transitions from: [ :registered, :preliminary ], to: :preliminary, if: :value_present?
        transitions from: [ :final ], to: :final, unless: :changed?
        transitions from: [ :final ], to: :amended, if: :changed?
        transitions from: [ :amended ], to: :amended
        transitions from: [ :cancelled ], to: :cancelled
      end

      event :certify do
        transitions from: [ :preliminary, :final ], to: :final
      end

      event :force_certify do
        transitions from: [ :registered, :cancelled ], to: :cancelled, if: :not_performed?
        transitions from: [ :preliminary, :final ], to: :final
      end
    end
  end
end
