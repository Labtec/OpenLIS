# frozen_string_literal: true

module FHIRable
  module Quantity
    extend ActiveSupport::Concern

    def fhirable_quantity(value, decimal_precision: 0, comparator: nil, unit: nil)
      return unless value

      FHIR::Quantity.new(
        value: ApplicationController.helpers.number_with_precision(value, precision: decimal_precision),
        comparator: comparator,
        unit: unit&.expression,
        system: 'http://unitsofmeasure.org',
        code: unit&.ucum
      )
    end
  end
end
