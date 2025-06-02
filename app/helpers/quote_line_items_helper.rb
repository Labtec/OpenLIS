# frozen_string_literal: true

module QuoteLineItemsHelper
  def options_for_discount_unit
    [
      [ "%", "percentage" ],
      [ "$", "currency" ]
    ]
  end

  def quote_line_item_code(line_item)
    return "#{line_item.procedure}×#{line_item.procedure_quantity}" if line_item.procedure_quantity.present? &&
                                                                       line_item.procedure_quantity > 1

    line_item.procedure
  end

  def quote_line_item_description(line_item)
    line_item.name
  end
end
