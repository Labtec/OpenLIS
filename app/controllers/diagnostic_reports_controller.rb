# frozen_string_literal: true

class DiagnosticReportsController < ApplicationController
  before_action :recent_patients
  before_action :set_diagnostic_report, only: %i[show edit update certify email]

  def index
    @diagnostic_reports = Accession.includes(:patient, :reporter).recently.reported.page(page)
  end

  def show
    @patient = @diagnostic_report.patient
    @results = @diagnostic_report.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)

    respond_to do |format|
      format.html
      format.pdf do
        signature = ActiveRecord::Type::Boolean.new.cast(params[:signature])
        pdf = LabReport.new(@patient, @diagnostic_report, @results, signature, view_context)
        send_data(pdf.render, filename: "resultados_#{@diagnostic_report.id}.pdf",
                              type: 'application/pdf', disposition: 'inline')
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_reports_url
  end

  def edit
    @patient = @diagnostic_report.patient
    results = @diagnostic_report.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)
    results.each do |department, _result|
      @diagnostic_report.notes.build(department_id: department.id) unless @diagnostic_report.try(:notes).find_by(department_id: department.id)
    end
  end

  def update
    @patient = @diagnostic_report.patient

    if @diagnostic_report.update(diagnostic_report_params)
      @diagnostic_report.transaction do
        @diagnostic_report.lock!
        @diagnostic_report.results.map(&:evaluate!)
        @diagnostic_report.evaluate!
      end

      redirect_to diagnostic_report_url(@diagnostic_report), notice: t('flash.diagnostic_report.update')
    else
      render :edit
    end
  end

  def certify
    if ActiveRecord::Type::Boolean.new.cast(params[:force])
      if current_user.admin?
        @diagnostic_report.transaction do
          @diagnostic_report.lock!
          @diagnostic_report.results.map(&:evaluate!)
          @diagnostic_report.reporter_id = current_user.id
          @diagnostic_report.reported_at = Time.current
          @diagnostic_report.results.map(&:not_performed!)
          @diagnostic_report.results.map(&:certify!)
          @diagnostic_report.certify!
          @diagnostic_report.save
          redirect_to diagnostic_report_url(@diagnostic_report, format: 'pdf')
        end
      end
    else
      @diagnostic_report.transaction do
        @diagnostic_report.lock!
        @diagnostic_report.results.map(&:evaluate!)
        if @diagnostic_report.complete?
          @diagnostic_report.reporter_id = current_user.id
          @diagnostic_report.reported_at = Time.current
          @diagnostic_report.results.map(&:certify!)
          @diagnostic_report.certify!
          @diagnostic_report.save
          redirect_to diagnostic_report_url(@diagnostic_report, format: 'pdf')
        else
          flash[:error] = t('flash.diagnostic_report.report_error')
          redirect_to diagnostic_report_url(@diagnostic_report)
        end
      end
    end
  end

  def email
    @patient = @diagnostic_report.patient
    @results = @diagnostic_report.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)

    pdf = LabReport.new(@patient, @diagnostic_report, @results, true, view_context)

    case params[:to]
    when 'practitioner'
      if @diagnostic_report.doctor.email.present?
        ResultsMailer.email_doctor(@diagnostic_report, pdf).deliver_now
        @diagnostic_report.update(emailed_doctor_at: Time.zone.now)
        redirect_to diagnostic_report_url(@diagnostic_report), notice: t('flash.diagnostic_report.email_success')
        return
      end
    when 'patient'
      if @patient.email.present?
        ResultsMailer.email_patient(@diagnostic_report, pdf).deliver_now
        @diagnostic_report.update(emailed_patient_at: Time.zone.now)
        redirect_to diagnostic_report_url(@diagnostic_report), notice: t('flash.diagnostic_report.email_success')
        return
      end
    end
    redirect_to diagnostic_report_url(@diagnostic_report), error: t('flash.diagnostic_report.email_error')
  end

  protected

  def set_diagnostic_report
    @diagnostic_report = Accession.find(params[:id])
  end

  def recent_patients
    @recent_patients ||= Patient.cached_recent
  end

  private

  def diagnostic_report_params
    params.require(:accession).permit({ results_attributes: %i[id lab_test_value_id value] }, notes_attributes: %i[id content department_id])
  end

  def page
    params[:page].to_i
  end
end
