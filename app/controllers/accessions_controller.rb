# frozen_string_literal: true

class AccessionsController < ApplicationController
  before_action :recent_patients, except: [:destroy]
  before_action :departments, only: %i[new create edit update]
  before_action :panels, only: %i[new create edit update]

  def index
    @pending_accessions = Accession.queued.pending.page(pending_page)
    @reported_accessions = Accession.recently.reported.page(page)
  end

  def show
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @results = @accession.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('flash.accession.accession_not_found')
    redirect_to accessions_url
  end

  def new
    @patient = Patient.find(params[:patient_id])
    @accession = @patient.accessions.build
    @accession.drawn_at = Time.current
    @accession.drawer_id = current_user.id
    @accession.received_at = Time.current
    @accession.receiver_id = current_user.id
    @users = User.sorted
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @accession = @patient.accessions.build(accession_params)
    @users = User.sorted
    if @accession.save
      flash[:notice] = t('flash.accession.create')
      redirect_to accession_url(@accession)
    else
      render action: 'new'
    end
  end

  def edit
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @users = User.sorted
    $update_action = 'edit'
  end

  def update
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @users = User.sorted
    if @accession.update(accession_params)
      unless current_user.admin?
        @accession.update(reporter_id: current_user.id, reported_at: Time.current) if @accession.reported_at
      end
      flash[:notice] = t('flash.accession.update')
      redirect_to accession_url(@accession)
    else
      render action: $update_action
    end
  end

  def destroy
    @accession = Accession.find(params[:id])
    @accession.destroy
    flash[:notice] = t('flash.accession.destroy')
    redirect_to patient_url(@accession.patient_id)
  end

  def edit_results
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    results = @accession.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)
    # TODO: Missing per department blank validation.
    # It will only check first
    results.each do |department, _result|
      unless @accession.try(:notes).find_by(department_id: department.id)
        @accession.notes.build(department_id: department.id)
      end
    end
    $update_action = 'edit_results'
  end

  def report
    @accession = Accession.find(params[:id])
    if @accession.complete?
      @accession.reporter_id = current_user.id
      @accession.reported_at = Time.current
      @accession.save
      redirect_to accession_results_url(@accession, format: 'pdf')
    else
      flash[:error] = t('flash.accession.report_error')
      redirect_to accession_url(@accession)
    end
  end

  def email_patient
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @results = @accession.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)

    pdf = LabReport.new(@patient, @accession, @results, view_context)

    if @patient.email.present?
      ResultsMailer.email_patient(@accession, pdf).deliver_now
      redirect_to accession_url(@accession), notice: t('flash.accession.email_success')
      @accession.update(emailed_patient_at: Time.zone.now)
    else
      redirect_to accession_url(@accession), error: t('flash.accession.email_error')
    end
  end

  def email_doctor
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @results = @accession.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)

    pdf = LabReport.new(@patient, @accession, @results, view_context)

    if @accession.doctor.email.present?
      ResultsMailer.email_doctor(@accession, pdf).deliver_now
      redirect_to accession_url(@accession), notice: t('flash.accession.email_success')
      @accession.update(emailed_doctor_at: Time.zone.now)
    else
      redirect_to accession_url(@accession), error: t('flash.accession.email_error')
    end
  end

  protected

  def recent_patients
    @recent_patients ||= Patient.cached_recent
  end

  def departments
    @departments ||= Department.cached_tests
  end

  def panels
    @panels ||= Panel.cached_panels
  end

  private

  def accession_params
    params.require(:accession).permit(:drawn_at, :drawer_id, :received_at, :receiver_id, :doctor_name, :icd9, { lab_test_ids: [] }, :reporter_id, :reported_at, { results_attributes: %i[id lab_test_id lab_test_value_id value] }, { panel_ids: [] }, notes_attributes: %i[id content department_id])
  end

  def pending_page
    params[:pending_page].to_i
  end

  def page
    params[:page].to_i
  end
end
