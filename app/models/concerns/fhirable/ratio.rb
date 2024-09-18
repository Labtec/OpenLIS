# frozen_string_literal: true

module FHIRable
  module Ratio
    extend ActiveSupport::Concern
    include FHIRable::Quantity

    def fhirable_ratio(ratio, decimal_precision: 0, unit: nil)
      FHIR::Ratio.new(numerator: fhirable_quantity(ratio.numerator, decimal_precision:, unit:),
                      denominator: fhirable_quantity(ratio.denominator, decimal_precision:, unit:))
    end
  end
end
