# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy history]

  def index
    @patients = Patient.search(params[:search]).page(page)
  end

  def show
    @accessions = @patient.accessions.recently.queued.page(page)
    @quotes = @patient.quotes.recent.active
  rescue ActiveRecord::RecordNotFound
    redirect_to patients_url, alert: t(".patient_not_found")
  end

  def new
    @patient = Patient.new
  end

  def edit; end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to patient_url(@patient), notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to patient_url(@patient), notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  def history
    @bundle = FHIR::Bundle.new
    meta = FHIR::Meta.new("lastUpdated" => @patient.updated_at.iso8601)
    @bundle.id = @patient.uuid
    @bundle.type = "history"
    @bundle.meta = meta
    @bundle.entry = FHIR.from_contents(@patient.to_json)

    respond_to do |format|
      format.json { render json: @bundle.to_json }
      format.xml { render xml: @bundle.to_xml }
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.expect(patient: [
      :given_name,
      :middle_name,
      :family_name,
      :family_name2,
      :partner_name,
      :gender,
      :birthdate,
      :identifier,
      :email,
      :cellular,
      :phone,
      :deceased,
      :animal_type,
      :insurance_provider_id,
      :policy_number,
      :identifier_type,
      :address_province,
      :address_district,
      :address_corregimiento,
      :address_line
    ])
  end

  def page
    params[:page].to_i
  end
end
