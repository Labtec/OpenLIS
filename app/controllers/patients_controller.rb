# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :recent_patients, except: %i[update destroy]

  def index
    @patients = Patient.search(params[:search]).page(params[:page])
  end

  def show
    @patient = Patient.find(params[:id])
    @pending_accessions = @patient.accessions
                                  .queued.pending.page(params[:pending_page])
    @reported_accessions = @patient.accessions
                                   .recently.reported.page(params[:page])
  rescue ActiveRecord::RecordNotFound
    redirect_to patients_url, alert: t('.patient_not_found')
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to @patient, notice: t('.success')
    else
      render action: 'new'
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update(patient_params)
      redirect_to @patient, notice: t('.success')
    else
      render action: 'edit'
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
    redirect_to patients_url, notice: t('.success')
  end

  protected

  def recent_patients
    @recent_patients ||= Patient.cached_recent
  end

  private

  def patient_params
    params.require(:patient).permit(
      :given_name, :middle_name, :family_name, :family_name2, :partner_name,
      :gender, :birthdate, :identifier, :email, :cellular, :phone, :address,
      :animal_type, :insurance_provider_id, :policy_number
    )
  end
end
