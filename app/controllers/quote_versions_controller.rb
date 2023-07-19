class QuoteVersionsController < ApplicationController
  before_action :set_departments, only: %i[new create edit update]
  before_action :set_panels, only: %i[new create edit update]
  before_action :set_quote, only: %i[show edit update destroy]

  def new
    previous_quote = Quote.find(params[:quote_id])
    parent_quote = previous_quote.parent_quote || previous_quote
    @quote = parent_quote.versions.build
    @quote.serial_number = parent_quote.serial_number
    @quote.patient_id = previous_quote.patient_id
    @quote.doctor_id = previous_quote.doctor_id
    @quote.panel_ids = previous_quote.panel_ids
    @quote.lab_test_ids = previous_quote.lab_test_ids

    @patient = previous_quote.patient
  end

  def show
    render partial: 'quotes/show', quote: @quote
  end

  def edit
    @quote = Quote.find(params[:id])
    @patient = @quote.patient
  end

  def create
  end

  def update
    @quote = Quote.find(params[:id])
    if @quote.update(quote_params) && @quote.draft?
      redirect_to quote_url(@quote), notice: t('flash.quote_detail.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def set_departments
    @departments ||= Department.cached_tests
  end

  def set_panels
    @panels ||= Panel.cached_panels
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
    @patient = @quote&.patient
  end

  def quote_params
    params.require(:quote).permit(:patient_id, :doctor_name, :note, { lab_test_ids: [] }, { panel_ids: [] }, :parent_quote_id)
  end

  def set_parent_quote_params
    parent_quote = Quote.find(params[:parent_quote_id])
    @quote.parent_quote = parent_quote
    @quote.serial_number = parent_quote.serial_number
    @quote.version_number = parent_quote.last_version_number + 1
    @quote.panel_ids = parent_quote.panel_ids
    @quote.lab_test_ids = parent_quote.lab_test_ids
  end
end
