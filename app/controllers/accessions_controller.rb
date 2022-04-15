# frozen_string_literal: true

class AccessionsController < ApplicationController
  before_action :recent_patients, except: [:destroy]
  before_action :departments, only: %i[new create edit update]
  before_action :panels, only: %i[new create edit update]
  before_action :set_accession, only: %i[edit update destroy]
  before_action :set_patient, only: %i[new create]
  before_action :set_accession_patient, only: %i[edit update]
  before_action :set_users, only: %i[new create edit update]

  def index
    @accessions = Accession.includes(:patient, :drawer).queued.pending.page(page)
  end

  def new
    @accession = @patient.accessions.build(
      drawn_at: Time.current,
      drawer_id: current_user.id,
      received_at: Time.current,
      receiver_id: current_user.id
    )
  end

  def edit; end

  def create
    @accession = @patient.accessions.build(accession_params)

    if @accession.save
      redirect_to diagnostic_report_url(@accession), notice: t('flash.accession.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @accession.update(accession_params)
      @accession.transaction do
        @accession.lock!
        @accession.update(reporter_id: current_user.id,
                          reported_at: Time.current) if @accession.reported_at && !current_user.admin?
        @accession.results.map(&:evaluate!)
        @accession.evaluate!
      end

      redirect_to diagnostic_report_url(@accession), notice: t('flash.accession.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @accession.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: t('flash.accession.destroy') }
      format.turbo_stream { flash.now[:notice] = t('flash.accession.destroy') }
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

  def set_accession
    @accession = Accession.find(params[:id])
  end

  def set_accession_patient
    @patient = @accession.patient
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
