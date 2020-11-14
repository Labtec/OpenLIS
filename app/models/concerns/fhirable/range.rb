# frozen_string_literal: true

module FHIRable
  module Range
    extend ActiveSupport::Concern
    include FHIRable::Quantity

    def fhirable_range(range, decimal_precision: 0, unit: nil)
      FHIR::Range.new(low: fhirable_quantity(range.begin, decimal_precision: decimal_precision, unit: unit),
                      high: fhirable_quantity(range.end, decimal_precision: decimal_precision, unit: unit))
    end
  end
end
