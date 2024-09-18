# frozen_string_literal: true

module UnitsHelper
  def options_for_unit
    options = []

    Unit.all.each do |u|
      options << [unit_expression_for_display(u), u.id]
    end

    options
  end

  def unit_expression_for_display(unit)
    return if unit.blank?

    unit.expression.presence || unit.ucum
  end
end
