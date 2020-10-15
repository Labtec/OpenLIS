# frozen_string_literal: true

class AccessionsController < ApplicationController
  before_action :recent_patients, except: [:destroy]
  before_action :departments, only: %i[new create edit update]
  before_action :panels, only: %i[new create edit update]
  before_action :set_accession, only: %i[edit update destroy]
  before_action :set_patient, only: %i[new create]
  before_action :set_users, only: %i[new create edit update]

  def index
    @accessions = Accession.queued.pending.page(page)
  end

  def new
    @accession = @patient.accessions.build

    @accession.drawn_at = Time.current
    @accession.drawer_id = current_user.id
    @accession.received_at = Time.current
    @accession.receiver_id = current_user.id
  end

  def create
    @accession = @patient.accessions.build(accession_params)

    if @accession.save
      redirect_to diagnostic_report_url(@accession), notice: t('flash.accession.create')
    else
      render :new
    end
  end

  def edit
    @patient = @accession.patient
  end

  def update
    @patient = @accession.patient

    if @accession.update(accession_params)
      @accession.transaction do
        @accession.lock!
        unless current_user.admin?
          @accession.update(reporter_id: current_user.id, reported_at: Time.current) if @accession.reported_at
        end
        @accession.results.map(&:evaluate!)
        @accession.evaluate!
      end

      redirect_to diagnostic_report_url(@accession), notice: t('flash.accession.update')
    else
      render :edit
    end
  end

  def destroy
    @accession.destroy
    redirect_to patients_url, notice: t('flash.accession.destroy')
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

  def set_accession
    @accession = Accession.find(params[:id])
  end

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_users
    @users = User.sorted
  end

  def accession_params
    params.require(:accession).permit(:drawn_at, :drawer_id, :received_at, :receiver_id, :doctor_name, :icd9, { lab_test_ids: [] }, :reporter_id, :reported_at, { results_attributes: %i[id lab_test_id lab_test_value_id value] }, { panel_ids: [] }, notes_attributes: %i[id content department_id])
  end

  def page
    params[:page].to_i
  end
end
