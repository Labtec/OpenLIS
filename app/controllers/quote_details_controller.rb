# frozen_string_literal: true

class QuoteDetailsController < ApplicationController
  def edit
    @quote = Quote.find(params[:id])
    @patient = @quote.patient
  end

  def update
    @quote = Quote.find(params[:id])
    if @quote.update(quote_params) && @quote.draft?
      redirect_to quote_url(@quote), notice: t("flash.quote_detail.update")
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def quote_params
    params.expect(quote: [
      { line_items_attributes: [ [
        :id,
        :quantity,
        :discount_value,
        :discount_unit
      ] ] },
      :note,
      :shipping_and_handling
    ])
  end
end
