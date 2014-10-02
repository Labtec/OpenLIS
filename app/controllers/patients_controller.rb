class PatientsController < ApplicationController
  before_filter :require_user
  before_filter :set_recent_patients_list, :except => [:update, :destroy]

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
    @patient = Patient.new(params[:patient])
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
    if @patient.update_attributes(params[:patient])
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

private

  def set_recent_patients_list
    @recent ||= Patient.recent
  end
end
