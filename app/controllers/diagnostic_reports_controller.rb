# frozen_string_literal: true

class DiagnosticReportsController < ApplicationController
  before_action :set_diagnostic_report, only: %i[show edit update certify force_certify email]
  before_action :set_results, only: %i[show edit email]

  def index
    @diagnostic_reports = Accession.includes(:patient, :reporter).recently.reported.page(page)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @diagnostic_report.to_json }
      format.smart_health_card do
        issuer = Rails.application.config.issuer
        @smart_health_card = issuer.issue_health_card(@diagnostic_report.to_bundle(issuer.url),
                                                      type: @diagnostic_report.payload_type)
        send_data @smart_health_card.to_json, type: :smart_health_card,
                                              filename: "resultados_#{@diagnostic_report.id}.smart-health-card"
      end
      format.pdf do
        signature = ActiveRecord::Type::Boolean.new.cast(params[:signature])
        smart = ActiveRecord::Type::Boolean.new.cast(params[:smart])
        loinc = ActiveRecord::Type::Boolean.new.cast(params[:loinc])
        pdf = LabReport.new(@patient, @diagnostic_report, @results, signature, smart, loinc, view_context)
        send_data(pdf.render, filename: "resultados_#{@diagnostic_report.id}.pdf",
                              type: "application/pdf", disposition: "inline")
      end
      format.xml { render xml: @diagnostic_report.to_xml }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_reports_url
  end

  def edit
    @results.each do |department, _result|
      @diagnostic_report.notes.build(department_id: department.id) unless @diagnostic_report.try(:notes).find_by(department_id: department.id)
    end
  end

  def update
    if @diagnostic_report.update(diagnostic_report_params)
      @diagnostic_report.transaction do
        @diagnostic_report.lock!
        @diagnostic_report.results.map(&:evaluate!) # XXXJL
        @diagnostic_report.evaluate!
      end

      redirect_to diagnostic_report_url(@diagnostic_report), notice: t("flash.diagnostic_report.update")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def certify
    @diagnostic_report.transaction do
      @diagnostic_report.lock!
      @diagnostic_report.results.map(&:evaluate!)
      if @diagnostic_report.complete?
        @diagnostic_report.reporter_id = current_user.id
        @diagnostic_report.reported_at = Time.current
        @diagnostic_report.results.map(&:certify!)
        @diagnostic_report.certify!
        @diagnostic_report.save
        redirect_to diagnostic_report_url(@diagnostic_report)
      else
        flash[:error] = t("flash.diagnostic_report.report_error")
        redirect_to diagnostic_report_url(@diagnostic_report), status: :unprocessable_content
      end
    end
  end

  def force_certify
    return unless current_user.admin?

    @diagnostic_report.transaction do
      @diagnostic_report.lock!
      @diagnostic_report.results.map(&:evaluate!)
      @diagnostic_report.reporter_id = current_user.id
      @diagnostic_report.reported_at = Time.current
      @diagnostic_report.results.map(&:not_performed!)
      @diagnostic_report.results.map(&:force_certify!)
      @diagnostic_report.force_certify!
      @diagnostic_report.save
      redirect_to diagnostic_report_url(@diagnostic_report)
    end
  end

  def email
    pdf = LabReport.new(@patient, @diagnostic_report, @results, true, false, false, view_context)

    case params[:to]
    when "practitioner"
      if @diagnostic_report.doctor.email.present?
        ResultsMailer.email_doctor(@diagnostic_report, pdf).deliver_now
        @diagnostic_report.update(emailed_doctor_at: Time.zone.now)
        redirect_to diagnostic_report_url(@diagnostic_report), notice: t("flash.diagnostic_report.email_success")
        return
      end
    when "patient"
      if @patient.email.present?
        ResultsMailer.email_patient(@diagnostic_report, pdf).deliver_now
        @diagnostic_report.update(emailed_patient_at: Time.zone.now)
        redirect_to diagnostic_report_url(@diagnostic_report), notice: t("flash.diagnostic_report.email_success")
        return
      end
    end
    redirect_to diagnostic_report_url(@diagnostic_report), error: t("flash.diagnostic_report.email_error")
  end

  private

  def set_diagnostic_report
    @diagnostic_report = Accession.includes(:patient).find(params[:id])
    @patient = @diagnostic_report.patient
  end

  def set_results
    @results = @diagnostic_report.results.includes(:patient, :accession, :department, :lab_test_value, { lab_test: [ :unit ] }, :unit).group_by(&:department).sort_by { |department, _results| department.position }
  end

  def diagnostic_report_params
    params.expect(accession: [
      { results_attributes: [ [
        :id,
        :lab_test_value_id,
        :value
      ] ] },
      notes_attributes: [ [
        :id,
        :content,
        :department_id
      ] ]
    ])
  end

  def page
    params[:page].to_i
  end
end
