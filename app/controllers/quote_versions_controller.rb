# frozen_string_literal: true

class QuoteVersionsController < ApplicationController
  before_action :set_departments
  before_action :set_panels
  before_action :set_quote_version

  def new; end

  protected

  def set_departments
    @departments ||= Department.cached_tests
  end

  def set_panels
    @panels ||= Panel.cached_panels
  end

  private

  def set_quote_version
    previous_quote = Quote.find(params[:quote_id])
    parent_quote = previous_quote.parent_quote || previous_quote

    @quote = parent_quote.versions.build
    @quote.serial_number = parent_quote.serial_number
    @quote.patient_id = previous_quote.patient_id
    @quote.doctor_id = previous_quote.doctor_id
    @quote.panel_ids = previous_quote.panel_ids
    @quote.lab_test_ids = previous_quote.lab_test_ids
    @quote.note = previous_quote.note
    @quote.shipping_and_handling = previous_quote.shipping_and_handling

    @patient = previous_quote.patient
  end
end
