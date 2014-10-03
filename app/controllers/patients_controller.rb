class PatientsController < ApplicationController
  before_filter :set_recent_patients_list, except: [:update, :destroy]

  def index
    @patients = Patient.sorted.search(params[:search], params[:page])
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      flash[:notice] = t('flash.patient.create')
      redirect_to patient_accessions_url(@patient)
    else
      render :action => 'new'
    end
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(patient_params)
      flash[:notice] = t('flash.patient.update')
      redirect_to patient_accessions_url(@patient)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
    flash[:notice] = t('flash.patient.destroy')
    redirect_to patients_url
  end

  protected

  def set_recent_patients_list
    @recent ||= Patient.recent
  end

  private

  def patient_params
    params.require(:patient).permit(:given_name, :middle_name, :family_name, :family_name2, :gender, :birthdate, :identifier, :email, :phone, :address, :animal_type, :insurance_provider_id, :policy_number)
  end
end
