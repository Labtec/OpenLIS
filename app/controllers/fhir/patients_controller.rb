# frozen_string_literal: true

module FHIR
  class PatientsController < BaseController
    before_action :set_patient, only: %i[show]

    def show
      render json: @patient
    end

    private

    def set_patient
      @patient = Object::Patient.find_by(uuid: params[:id])
    end
  end
end
