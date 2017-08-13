# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :set_recent_patients_list, except: %i[update destroy]

  def index
    @patients = Patient.search(params[:search]).page(params[:page])
  end

  def show
    @patient = Patient.find(params[:id])
    @pending_accessions = @patient.accessions
                                  .includes(:drawer,
                                            results: %i[lab_test lab_test_value])
                                  .queued.pending.page(params[:pending_page])
    @reported_accessions = @patient.accessions
                                   .includes(:reporter)
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
    if @patient.update_attributes(patient_params)
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

  def set_recent_patients_list
    @recent ||= Patient.cached_recent
  end

  private

  def patient_params
    params.require(:patient).permit(
      :given_name, :middle_name, :family_name, :family_name2, :partner_name,
      :gender, :birthdate, :identifier, :email, :phone, :address, :animal_type,
      :insurance_provider_id, :policy_number
    )
  end
end
