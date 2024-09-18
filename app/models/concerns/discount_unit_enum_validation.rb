# frozen_string_literal: true

module DiscountUnitEnumValidation
  extend ActiveSupport::Concern

  included do
    validates_inclusion_of :discount_unit, in: discount_units.keys

    def discount_unit=(value)
      super
    rescue ArgumentError
      @attributes.write_cast_value("discount_unit", value)
    end
  end
end
