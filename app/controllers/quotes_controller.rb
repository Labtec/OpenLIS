# frozen_string_literal: true

class QuotesController < ApplicationController
  before_action :set_departments, only: %i[new create edit update]
  before_action :set_panels, only: %i[new create edit update]
  before_action :set_quote, only: %i[show edit update destroy approve email order]

  def index
    @quotes = Quote.recent.active.page(page)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        signature = ActiveRecord::Type::Boolean.new.cast(params[:signature])
        pdf = PDFQuote.new(@quote, signature, view_context)
        send_data(pdf.render, filename: "#{@quote.serial_number}.pdf",
                              type: "application/pdf", disposition: "inline")
      end
    end
  end

  def new
    if params[:patient_id]
      @patient = Patient.find(params[:patient_id])
      @quote = @patient.quotes.build
    else
      @quote = Quote.new
    end
  end

  def edit; end

  def create
    @quote = Quote.new(quote_params)
    @quote.created_by = current_user

    if @quote.save
      redirect_to quote_url(@quote), notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @quote.update(quote_params) && @quote.draft?
      redirect_to quote_url(@quote), notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_url, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  def approve
    if @quote.draft?
      @quote.approved!
      @quote.update(approved_by: current_user)
      redirect_to quote_url(@quote)
    else
      flash[:error] = t("flash.quote.approve_error")
      redirect_to quote_url(@quote), status: :unprocessable_content
    end
  rescue StandardError
    flash[:error] = t("flash.quote.approve_error")
    redirect_to quote_url(@quote), status: :unprocessable_content
  end

  def email
    pdf = PDFQuote.new(@quote, true, view_context)
    if @patient.email.present?
      QuotesMailer.email_quote(@quote, pdf).deliver_now
      @quote.update(emailed_patient_at: Time.zone.now)
      redirect_to quote_url(@quote), notice: t("flash.quote.email_success")
      return
    end
    redirect_to quote_url(@quote), error: t("flash.quote.email_error")
  end

  def order
    service_request = @quote.build_service_request(
      patient: @quote.patient,
      panel_ids: @quote.panel_ids,
      lab_test_ids: @quote.panels_lab_test_ids,
      doctor: @quote.doctor,
      drawn_at: Time.current,
      drawer: current_user,
      received_at: Time.current,
      receiver: current_user
    )
    if service_request.save
      @quote.archive_other_versions
      redirect_to diagnostic_report_url(service_request), notice: t(".success")
    else
      render :show, status: :unprocessable_content
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
    params.require(:quote).permit(:patient_id, :doctor_name, :note, { lab_test_ids: [] }, { panel_ids: [] }, :parent_quote_id, :shipping_and_handling)
  end

  def page
    params[:page].to_i
  end
end
